//
//  CustomNavigationController.swift
//  DeathNote
//
//  Created by Ada 2018 on 02/10/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate is needed to implement the animation transition.
        delegate = self
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SlideAnimationController(presenting: TransitionMoviment.right)
        } else {
            return SlideAnimationController(presenting: TransitionMoviment.left)
        }
    }
}
