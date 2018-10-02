//
//  AnimationType.swift
//  FluidInterfaces
//
//  Created by Ada 2018 on 25/07/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

// This enum will inform the animation controller which animation class was selected based on the option that the user selected

public enum TransitionType {
    case fade
    case slide
    case slideFade
    case flip
    case story
    
    // This init is optionional, but recommended to select the option based on the tag of UISwitch
    public init?(rawValue: Int){
        switch rawValue {
        case 0:
            self = .fade
        case 1:
            self = .slide
        case 2:
            self = .slideFade
        case 3:
            self = .flip
        case 4:
            self = .story    
            
        default:
            return nil
        }
    }
}

public enum TransitionMoviment{
    case left
    case right
}

public class Transition{
    
    private var typeTransition: TransitionType
    private var transitionTime: Double = 0.5
    
    /// Needed to use the framework.
    ///
    /// - Parameters:
    ///   - typeTransition: Choose your transition
    ///   - transitionTime: Choose the time of transition
    public init(typeTransition: TransitionType,transitionTime: Double? = nil){
        self.typeTransition = typeTransition
        self.transitionTime = (transitionTime == nil) ? 0.5 : transitionTime!
    }
    
    
    /// This function can change the time after the initialize
    ///
    /// - Parameter time: Double
    public func changeTime(time: Double){
        self.transitionTime = time
    }
    
    
    /// If you want to use multiple transitions
    ///
    /// - Parameter typeTransition: Choose the new transtion
    public func changeType(typeTransition: TransitionType){
        self.typeTransition = typeTransition
    }
    
    
    
    /// The transition selected will be return the effect in this call
    ///
    /// - Parameter side: Choose your side transition effect
    /// - Returns: Return the effect of transtion
    public func runTransition(side: TransitionMoviment) -> UIViewControllerAnimatedTransitioning{
        switch self.typeTransition {
            case .fade:
                return FadeAnimationController()
            case .slide:
                return SlideAnimationController(presenting: side)
            case .slideFade:
                return FadeSlideAnimationController(presenting: side)
            case .flip:
                return FlipAnimationController(presenting: side)
            case .story:
                return StoryAnimationController(presenting: side)
        }
    }
}
