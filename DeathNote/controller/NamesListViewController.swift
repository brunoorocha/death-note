//
//  NamesListViewController.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit
import WatchConnectivity

class NamesListViewController: UIViewController, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	

	@IBOutlet weak var tableView: UITableView!	
	
	var persons: [Person] = [
		 Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init())),
		 Person(name: "Chiquim", deathType: .trampling, deathDay: Date(timeInterval: (3600.0 * 24.0), since: Date.init()), deathHour: Date(timeInterval: 120.0, since: Date.init())), Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init()))
	]
	
	var people = [String]()
	
	
	var dates: [String] = []
	
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
		
		self.tableView.register(UINib(nibName: "NamesListTableViewCell", bundle: nil), forCellReuseIdentifier: "NamesListTableViewCell")
		self.tableView.register(UINib(nibName: "DateTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateTableViewHeaderView")
		
		for person in persons {

			let date = getYearMonthAndDay(from: person.deathDay)
			
			if !self.dates.contains(date) {
				self.dates.append(date)
			}
		}
		
		self.dates.sort()
		
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		if let boolean = message["teste"] as? Bool, boolean {
			let replyMessage = people
			replyHandler(["persons":replyMessage, "success": true])
		}
	}
	
}

extension NamesListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.dates.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let personsInDay = self.persons.filter { (person) -> Bool in
			let date = getYearMonthAndDay(from: person.deathDay)
			return date == self.dates[section]
		}
		
		return personsInDay.count
	}
		
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48.0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateTableViewHeaderView") as? DateTableViewHeaderView {
		
			header.dateLabel.text = dates[section]
			return header
		}
		
		return UITableViewHeaderFooterView()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = self.tableView.dequeueReusableCell(withIdentifier: "NamesListTableViewCell", for: indexPath) as? NamesListTableViewCell {
			
			cell.nameLabel.text = persons[indexPath.row].name
			cell.deathHourLabel.text = getHoursMinutesAndSeconds(from: persons[indexPath.row].deathHour)
						
			return cell
		}
		
		return UITableViewCell()
	}
}
