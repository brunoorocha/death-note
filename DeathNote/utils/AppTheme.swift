//
//  AppTheme.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

struct Theme {
    var backgroundColor: UIColor
    var textColor: UIColor
    var primaryColor: UIColor
    var modalBackgroundColor: UIColor
    var backgroundNotificationColor: UIColor
}

struct Colors {
    
    // GRAY
    static let grayModal = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    static let grayBackground = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    static let grayBackgroundCardNotification = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 1, alpha: 0.1376819349)
    
    // WHITE
    static let white = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 1, alpha: 1)
    
    // BLACK
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    // RED
    static let red = #colorLiteral(red: 0.9882352941, green: 0.2392156863, blue: 0.2235294118, alpha: 1)
    
}

class AppColors {
    
    static var currentTheme: colorTheme = .dark
    
    internal static let darkTheme = Theme(backgroundColor: Colors.grayBackground, textColor: Colors.white, primaryColor: Colors.red, modalBackgroundColor: Colors.grayModal, backgroundNotificationColor: Colors.grayBackgroundCardNotification)
    
    internal enum colorTheme {
        case dark
        
        var colors: Theme {
            switch self {
            case .dark:
                return AppColors.darkTheme
            }
        }
    }
}
