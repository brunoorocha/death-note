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
		 Person(name: "Joãozim", deathType: .heartAttack, deathDay: Date.init(), deathHour: Date(timeInterval: 40.0, since: Date.init()))
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.tableView.register(UINib(nibName: "NamesListTableViewCell", bundle: nil), forCellReuseIdentifier: "NamesListTableViewCell")
	}
	
}

extension NamesListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.persons.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64.0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = self.tableView.dequeueReusableCell(withIdentifier: "NamesListTableViewCell", for: indexPath) as? NamesListTableViewCell {
			
			cell.nameLabel.text = persons[indexPath.row].name
			cell.deathHourLabel.text = getHoursMinutesAndSeconds(from: persons[indexPath.row].deathHour)
			
			print(persons[indexPath.row])
			return cell
		}
		
		return UITableViewCell()
	}
}
