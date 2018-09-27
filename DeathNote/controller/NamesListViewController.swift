//
//  NamesListViewController.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class NamesListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!	
	
	var persons: [Person] = [
		 Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init())),
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init()))
	]
	
	var dates: [Date] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.tableView.register(UINib(nibName: "NamesListTableViewCell", bundle: nil), forCellReuseIdentifier: "NamesListTableViewCell")
		self.tableView.register(UINib(nibName: "DateTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateTableViewHeaderView")
		
		for person in persons {
			self.dates.append(person.deathDay)
		}
		
	}
	
}

extension NamesListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let personsInDay = self.persons.filter { (person) -> Bool in
			return person.deathDay == self.dates[section]
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
		
			header.dateLabel.text = getYearMonthAndDay(from: dates[0])
			return header
		}
		
		return UITableViewHeaderFooterView()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = self.tableView.dequeueReusableCell(withIdentifier: "NamesListTableViewCell", for: indexPath) as? NamesListTableViewCell {
			
			cell.nameLabel.text = persons[indexPath.row].name
			cell.deathHourLabel.text = getHoursMinutesAndSeconds(from: persons[indexPath.row].deathHour)
			cell.deathTypeLabel.text = persons[indexPath.row].deathType.rawValue
			
			print(persons[indexPath.row])
			return cell
		}
		
		return UITableViewCell()
	}
}
