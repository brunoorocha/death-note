//
//  NamesListTableViewCell.swift
//  DeathNote
//
//  Created by Ada 2018 on 27/09/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class NamesListTableViewCell: UITableViewCell {

	@IBOutlet weak var deathTypeImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var deathHourLabel: UILabel!
    @IBOutlet weak var viewName: UIView!
    
	override func awakeFromNib() {
        super.awakeFromNib()
        
        let textColor = AppColors.currentTheme.colors.textColor
        let backgroundColor = AppColors.currentTheme.colors.backgroundColor
        
        deathHourLabel.textColor = textColor
        nameLabel.textColor = textColor
        
        contentView.backgroundColor = backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
