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
import UserNotifications

class NamesListInterfaceController: WKInterfaceController, WCSessionDelegate {
	@IBOutlet var namesListTable: WKInterfaceTable!
	@IBOutlet var todayNameLabel: WKInterfaceLabel!
	@IBOutlet var iconDeathImage: WKInterfaceImage!
	
	let dictionary = ["teste" : true]
	var values = [[String:String]]()
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
		self.todayNameLabel.setText("Today")
		self.iconDeathImage.setImage(#imageLiteral(resourceName: "skull_icon"))
		
		if WCSession.isSupported() {
			WCSession.default.delegate = self
			WCSession.default.activate()
		}
		
		UNUserNotificationCenter.current().delegate = self
    }
	
	override func didAppear() {
		WCSession.default.sendMessage(dictionary, replyHandler: {(reply) in
			let success = reply["success"] as! Bool
			if success == true {
				if let people = reply["persons"] as? [[String: String]] {
					self.values = people
					self.namesListTable.setNumberOfRows(self.values.count, withRowType: "NameListTableRow")
					
					for index in 0..<people.count {
						let row = self.namesListTable.rowController(at: index) as? RowController
						let labelValue = people[index]
						
						DispatchQueue.main.async {
							row?.nameLabel.setText(labelValue["name"])
						}
					}
				}
			}
		}, errorHandler: nil)
	}
	
    override func willActivate() {
		super.willActivate()
		WCSession.default.activate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
		return self.values[rowIndex]
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

extension NamesListInterfaceController: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		self.presentController(withName: "ProgressInterfaceController", context: notification.request.content.body)
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		if response.notification.request.content.categoryIdentifier == "SEE" {
			if response.actionIdentifier == "SEE_ACTION" {
				self.presentController(withName: "ProgressInterfaceController", context: self)
			}
		}
		
		
	}
}


