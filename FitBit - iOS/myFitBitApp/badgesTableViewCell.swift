//
//  badgesTableViewCell.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/7/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class badgesTableViewCell: UITableViewCell {

    
    
    //Properties
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mobileDescriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var badgeImageview: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
