//
//  ModalPresentationController.swift
//  DeathNote
//
//  Created by Ada 2018 on 02/10/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class ModalPresentationController: UIPresentationController {
	override var frameOfPresentedViewInContainerView: CGRect {
		guard let containerView = containerView else {
			return CGRect(origin: .zero, size: .zero)
		}
		
		var size = containerView.bounds.size
		size.height = size.height - containerView.frame.height * 0.15
		
		return CGRect(origin: CGPoint(x: 0, y: containerView.frame.height - size.height), size: size)
	}
	
	override func containerViewWillLayoutSubviews() {
		self.presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
//	override func dismissalTransitionWillBegin() {
//		if let controller = self.presentingViewController as? NamesListViewController {
//			
//		}
//	}
}
