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
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
	
	func sessionDidBecomeInactive(_ session: WCSession) {}
	
	func sessionDidDeactivate(_ session: WCSession) {}
	
	@IBOutlet weak var tableView: UITableView!
	
	var persons: [Person] = [
		 Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init())),
		 Person(name: "Chiquim", deathType: .trampling, deathDay: Date(timeInterval: (3600.0 * 24.0), since: Date.init()), deathHour: Date(timeInterval: 120.0, since: Date.init())), Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init()))
	]
	
	var tableData: [String: [Person]] = [:]
	var people = [String]()
	
	var dates: [String] = []
    
    let textColor = AppColors.currentTheme.colors.textColor
    let background = AppColors.currentTheme.colors.backgroundColor
    let primaryColor = AppColors.currentTheme.colors.primaryColor
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
		
		for i in 0..<persons.count {
			people.append(persons[i].name)
		}

		self.tableView.delegate = self
		self.tableView.dataSource = self
        
        tableView.backgroundColor = background
		
		self.tableView.register(UINib(nibName: "NamesListTableViewCell", bundle: nil), forCellReuseIdentifier: "NamesListTableViewCell")
		self.tableView.register(UINib(nibName: "DateTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateTableViewHeaderView")
		
		self.view.backgroundColor = background
        navigationController?.navigationBar.tintColor = primaryColor
        navigationController?.navigationBar.barTintColor = background

		loadTableData()		
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
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddNameModal" {
			let addNameModal = segue.destination as! AddNameModalViewController
			addNameModal.delegate = self
		}
	}

	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		if let boolean = message["teste"] as? Bool, boolean {
			let replyMessage = people
			replyHandler(["persons":replyMessage, "success": true])
		}
	}
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
		return 48.0
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
