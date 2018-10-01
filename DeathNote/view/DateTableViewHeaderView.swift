//
//  DayUITableViewHeaderFooterView.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class DateTableViewHeaderView: UITableViewHeaderFooterView {
	
	@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.backgroundColor = AppColors.currentTheme.colors.backgroundColor
        dateLabel.textColor = AppColors.currentTheme.colors.textColor
    }
}
