//
//  NamesListInterfaceController.swift
//  DeathNote WatchKit Extension
//
//  Created by Ada 2018 on 01/10/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class NamesListInterfaceController: WKInterfaceController, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}
	
	@IBOutlet var namesListTable: WKInterfaceTable!
	@IBOutlet var testImage: WKInterfaceImage!
	
	let dictionary = ["teste" : true]
	var values = [String]()
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
		self.testImage.setImage(#imageLiteral(resourceName: "fourth_seconds_circle_progress_status_0"))
		
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
    }
	
	override func didAppear() {
		WCSession.default.sendMessage(dictionary, replyHandler: { (reply) in
			let success = reply["success"] as! Bool
			if success == true {
				if let people = reply["persons"] as? [String] {
					self.values = people
					self.namesListTable.setNumberOfRows(self.values.count, withRowType: "NameListTableRow")
					for index in 0..<people.count {
						let row = self.namesListTable.rowController(at: index) as? RowController
						let labelValue = people[index]
						DispatchQueue.main.async {
							row?.nameLabel.setText(labelValue)
						}
					}
				}
			}
		}, errorHandler: nil)
	}
	
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
		return self.values[rowIndex]
	}
}
