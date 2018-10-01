//
//  AddPersonDelegate.swift
//  DeathNote
//
//  Created by Ada 2018 on 01/10/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import Foundation

protocol AddPersonDelegate {
	func addPersonWith(name: String, deathType: DeathType, deathDate: Date)
}
