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
	
	let dictionary = ["teste" : true]
	var values = [String]()
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
		self.namesListTable.setNumberOfRows(self.dictionary.count, withRowType: "NameListTableRow")
		
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
    }
	
	override func didAppear() {
		WCSession.default.sendMessage(dictionary, replyHandler: { (reply) in
			let success = reply["success"] as! Bool
			if success == true {
				if let people = reply["persons"] as? [Person]{
					self.values = people.map { $0.name }
					for (index,person) in people.enumerated() {
						let row = self.namesListTable.rowController(at: index) as? RowController
						let labelValue = person.name
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
		return self.values.count
	}
}
