//
//  ProgressStatusInterfaceController.swift
//  DeathNote WatchKit Extension
//
//  Created by Ada 2018 on 01/10/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import WatchKit
import Foundation

class ProgressStatusInterfaceController: WKInterfaceController {
	@IBOutlet var nameLabel: WKInterfaceLabel!
	@IBOutlet var circleProgressBarImage: WKInterfaceImage!
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
		if let nameLabel = context as? String {
			self.nameLabel.setText(nameLabel)
		}
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		
		self.circleProgressBarImage.setImageNamed("fourth_seconds_circle_progress_status_")
		self.circleProgressBarImage.startAnimatingWithImages(in: NSRange(location: 0, length: 42), duration: 42, repeatCount: 1)
		
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
