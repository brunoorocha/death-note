//
//  DetailsInterfaceController.swift
//  DeathNote WatchKit Extension
//
//  Created by Ada 2018 on 02/10/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import WatchKit
import Foundation

class DetailsInterfaceController: WKInterfaceController {
	@IBOutlet var nameLabel: WKInterfaceLabel!
	@IBOutlet var deathTypeLabel: WKInterfaceLabel!
	@IBOutlet var deathTimeLabel: WKInterfaceLabel!
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
		if let object = context as? [String: String] {
			self.nameLabel.setText(object["name"])
			self.deathTypeLabel.setText(object["death_type"])
			self.deathTimeLabel.setText(object["death_day"])
		}
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
