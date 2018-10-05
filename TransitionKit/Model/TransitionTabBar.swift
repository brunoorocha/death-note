//
//  TransitionTabBar.swift
//  TransitionKit
//
//  Created by Thiago Valente on 11/09/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

public class TransitionTabBar {
    
    // Save the last and current tab bar item.
    var lastTabItemSelected: Int
    var currentTabItemSelected: Int
    
    /// Pass the initial tag to the tab bar learn the next side
    ///
    /// - Parameter item: Int
    public init(tag item: Int) {
        self.lastTabItemSelected = item
        self.currentTabItemSelected = item
    }
    
    /// Will calculate based on the old and curent tag selected.
    ///
    /// - Returns: TranstitionMoviment - Left / Right
    public func nextSide() -> TransitionMoviment{
        if(self.currentTabItemSelected > self.lastTabItemSelected){
            return .right
        }else{
            return .left
        }
    }
    
    /// Needed call this function always the tabBar is selected
    ///
    /// - Parameter item: Int - Current tag item.
    public func tabBarItemSelected(tag item: Int){
        self.lastTabItemSelected = self.currentTabItemSelected
        self.currentTabItemSelected = item
    }
}

