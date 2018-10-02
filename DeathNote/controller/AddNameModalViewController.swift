//
//  AddNameModalViewController.swift
//  DeathNote
//
//  Created by Ada 2018 on 01/10/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class AddNameModalViewController: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var deathIssueTextField: UITextField!
	@IBOutlet weak var timeOfDeathTextField: UITextField!
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var modalView: UIView!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	
	var delegate: AddPersonDelegate?
	
	var keyboardToolBar: UIToolbar = {
		var toolbar = UIToolbar()
		
		var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapOnDoneKeyboardToolBarButton))
		var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([flexibleSpace, doneButton], animated: false)
		toolbar.isUserInteractionEnabled = true
		toolbar.sizeToFit()
		
		return toolbar
	}()

	
	var deathIssues = [DeathType.heartAttack, DeathType.drowning, DeathType.trampling]
	var dateSelected: Date?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.nameTextField.inputAccessoryView = self.keyboardToolBar
		self.deathIssueTextField.inputAccessoryView = self.keyboardToolBar
		self.timeOfDeathTextField.inputAccessoryView = self.keyboardToolBar
		
		let deathIssuePicker: UIPickerView = {
			let picker = UIPickerView()
			
			picker.delegate = self
			picker.dataSource = self
			
			return picker
		}()
		
		let deathDatePicker = UIDatePicker()
		deathDatePicker.date = Date(timeInterval: 40, since: Date.init())
		deathDatePicker.addTarget(self, action: #selector(didChangeDeathDatePicker), for: .valueChanged)
		
		self.deathIssueTextField.inputView = deathIssuePicker
		self.timeOfDeathTextField.inputView = deathDatePicker
		
		self.deathIssueTextField.text = deathIssues[0].rawValue
		self.timeOfDeathTextField.text = getDateAndTime(from: deathDatePicker.date)
		self.dateSelected = deathDatePicker.date
		
		self.navigationBar.barTintColor = AppColors.currentTheme.colors.backgroundColor
		self.navigationBar.tintColor = AppColors.currentTheme.colors.textColor
		self.cancelButton.tintColor = AppColors.currentTheme.colors.textColor
		self.saveButton.tintColor = AppColors.currentTheme.colors.primaryColor
		
    }

	@IBAction func didTapOnCancelButton(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didTapOnSaveButton(_ sender: UIBarButtonItem) {
		
		let name = self.nameTextField.text
		let deathType = DeathType.init(rawValue: self.deathIssueTextField.text!)
		let deathDate = self.dateSelected
		
		delegate?.addPersonWith(name: name!, deathType: deathType!, deathDate: deathDate!)
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func didTapOnDoneKeyboardToolBarButton() {
		self.view.endEditing(true)
	}
	
	@objc func didChangeDeathDatePicker(_ sender: UIDatePicker) {
		self.timeOfDeathTextField.text = getDateAndTime(from: sender.date)
		self.dateSelected = sender.date
	}
	
}

extension AddNameModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.deathIssues.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.deathIssues[row].rawValue
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.deathIssueTextField.text = self.deathIssues[row].rawValue
	}
}

