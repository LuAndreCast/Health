//
//  stepTableViewCell.swift
//  Health
//
//  Created by Luis Castillo on 3/28/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class stepTableViewCell: UITableViewCell {

    
    var stepInfo:Step?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }//eom

    
    func setCellContent(step:Step)
    {
        stepInfo = step
        
        //date
        let date:Int = step.dateInt
        if date > 0
        {
            self.textLabel?.text = "\(date)"
        }
        else
        {
            self.textLabel?.text = step.dateString
        }
        
        //steps
        self.detailTextLabel?.text = step.steps

    }//eom
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
