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
		 Person(name: "Pedim", deathType: .drowning, deathDay: Date.init(), deathHour: Date(timeInterval: 120.0, since: Date.init())),
		Person(name: "Chiquim", deathType: .trampling, deathDay: Date(timeInterval: (3600.0 * 24.0), since: Date.init()), deathHour: Date(timeInterval: 120.0, since: Date.init()))
	]
	
	var tableData: [String: [Person]] = [:]
	
	var dates: [String] = []
	
	var addNameModalViewController: AddNameModalViewController?
    
    let textColor = AppColors.currentTheme.colors.textColor
    let background = AppColors.currentTheme.colors.backgroundColor
    let primaryColor = AppColors.currentTheme.colors.primaryColor
    
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
}

extension NamesListViewController: AddPersonDelegate {
	func addPersonWith(name: String, deathType: DeathType, deathDate: Date) {
		let newPerson = Person(name: name, deathType: deathType, deathDay: deathDate, deathHour: deathDate)
		self.persons.append(newPerson)
		
		self.persons.sort { (person1, person2) -> Bool in
			return person1.deathDay < person2.deathDay
		}
		
		self.loadTableData()
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
			
//			let index = indexPath.section > 0 ? indexPath.row + tableView.numberOfRows(inSection: (indexPath.section - 1)) : indexPath.row + indexPath.section
			
//			print("Section: \(indexPath.section), item: \(indexPath.item), index: \(index)")
			
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
