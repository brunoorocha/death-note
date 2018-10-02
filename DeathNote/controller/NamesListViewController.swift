//
//  NamesListViewController.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

class NamesListViewController: UIViewController, WCSessionDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	var persons: [Person] = [
		Person(name: "Yagami", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		Person(name: "Amane", deathType: .trampling, deathDay: Date.init(), deathHour: Date(timeInterval: 90.0, since: Date.init())),
		Person(name: "Lawliet", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init()))
	]
	
	var tableData: [String: [Person]] = [:]
	var people = [[String:String]]()
	
	var dates: [String] = []
	
	var addNameModalViewController: AddNameModalViewController?

    let textColor = AppColors.currentTheme.colors.textColor
    let background = AppColors.currentTheme.colors.backgroundColor
    let primaryColor = AppColors.currentTheme.colors.primaryColor
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
		
		appendPeople()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
        tableView.backgroundColor = background
		
		self.tableView.register(UINib(nibName: "NamesListTableViewCell", bundle: nil), forCellReuseIdentifier: "NamesListTableViewCell")
		self.tableView.register(UINib(nibName: "DateTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateTableViewHeaderView")
		
		self.view.backgroundColor = background
        navigationController?.navigationBar.tintColor = primaryColor
        navigationController?.navigationBar.barTintColor = background

		loadTableData()
		startDeathChecking()
	}
	
	func loadTableData() {
		self.dates = []
		for person in self.persons {
			let date = formatterToLongStyle(with: person.deathDay)
			if !self.dates.contains(date) {
				self.dates.append(date)
			}
		}
		self.dates.sort()
		
		for date in self.dates {
			self.tableData[date] = self.persons.filter({ (person) -> Bool in
				return date == formatterToLongStyle(with: person.deathDay)
			})
		}
		self.tableView.reloadData()
	}
	
	func appendPeople() {
		self.people.removeAll()
		
		let todayDate = formatterToLongStyle(with: Date.init())
		let peopleToDie = self.persons.filter({ (person) -> Bool in
			return formatterToLongStyle(with: person.deathDay) == todayDate
		})
		
		for i in 0..<peopleToDie.count {
			var p: [String:String] = [:]
			p["name"] = peopleToDie[i].name
			p["death_type"] = peopleToDie[i].deathType.rawValue
			p["death_day"] = getHoursMinutesAndSeconds(from: peopleToDie[i].deathDay)
			
			self.people.append(p)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddNameModal" {
			self.addNameModalViewController = segue.destination as? AddNameModalViewController
			self.addNameModalViewController?.delegate = self
			self.addNameModalViewController?.transitioningDelegate = self
			self.addNameModalViewController?.modalPresentationStyle = .custom
		}
	}
	
	func startDeathChecking() {
		Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
			let nextHumansToDie = self.persons.filter({ (person) -> Bool in
				return Date(timeInterval: 40, since: Date.init()) >= person.deathDay
			})
			
			print(nextHumansToDie)
		}
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		if let boolean = message["teste"] as? Bool, boolean {
			let replyMessage = people
			replyHandler(["persons":replyMessage, "success": true])
		}
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
	
	func sessionDidBecomeInactive(_ session: WCSession) {}
	
	func sessionDidDeactivate(_ session: WCSession) {}
}

extension NamesListViewController: AddPersonDelegate {
	func addPersonWith(name: String, deathType: DeathType, deathDate: Date) {
		let newPerson = Person(name: name, deathType: deathType, deathDay: deathDate, deathHour: deathDate)
		self.persons.append(newPerson)
		
		self.persons.sort { (person1, person2) -> Bool in
			return person1.deathDay < person2.deathDay
		}
		
		self.performToSendNotification(with: newPerson)
		self.loadTableData()
		appendPeople()
	}
	
	func performToSendNotification(with person: Person) {
		
		let notificationAction = UNNotificationAction(identifier: "SEE_ACTION", title: "See countdown", options: UNNotificationActionOptions(rawValue: 0))
		let notificationCategory = UNNotificationCategory(identifier: "SEE", actions: [notificationAction], intentIdentifiers: [], options: .customDismissAction)
		
		
		let notificationContent = UNMutableNotificationContent()
		notificationContent.title = "Death Alert"
		notificationContent.body = "\(person.name)"		
		notificationContent.sound = UNNotificationSound.default()
		notificationContent.categoryIdentifier = "SEE"
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
		let request = UNNotificationRequest(identifier: "DeathNoteNotification", content: notificationContent, trigger: trigger)
		
		UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
		
		UNUserNotificationCenter.current().add(request) { (error) in
			if error != nil {
				print(String(describing: error))
			}
		}
	}
}

extension NamesListViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		if let addNameModalViewController = self.addNameModalViewController {
			return ModalPresentationController(presentedViewController: addNameModalViewController, presenting: self)
		}
		
		return nil
	}
}

extension NamesListViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.tableData.keys.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let date = self.dates[section]
		
		guard let personsInSection = self.tableData[date] else {
			return 0
		}
		
		return personsInSection.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 64.0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateTableViewHeaderView") as? DateTableViewHeaderView {
			header.dateLabel.text = self.dates[section]
			return header
		}
		
		return UITableViewHeaderFooterView()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = self.tableView.dequeueReusableCell(withIdentifier: "NamesListTableViewCell", for: indexPath) as? NamesListTableViewCell {
			
			let date = self.dates[indexPath.section]
			
			guard let persons = self.tableData[date] else {
				return UITableViewCell()
			}
			
			cell.nameLabel.text = persons[indexPath.item].name
			cell.deathHourLabel.text = getHoursMinutesAndSeconds(from: persons[indexPath.item].deathHour)
			cell.selectionStyle = .none
			
			return cell
		}
		return UITableViewCell()
	}
}

