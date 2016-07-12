//
//  ActivityTableViewCell.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/9/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    //properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
