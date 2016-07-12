//
//  FriendsTableViewCell.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/8/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    
    
    //Properties
    
    @IBOutlet weak var friendImageview: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    
    //top badges
    @IBOutlet var topBadgesImageView: [UIImageView]!
    
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        friendImageview.image = UIImage(named: "defaultProfileFemale.gif")
    }//eom
    
    //MARK: - Achievements
    func setupAchievements(friendAchievements:NSArray)
    {
        for(var iter = 0 ; iter < friendAchievements.count ; iter++)
        {
            if let currAchievement:Achievement = friendAchievements .objectAtIndex(iter) as? Achievement
            {
                if let currImageView:UIImageView = topBadgesImageView[iter]
                {
                    currImageView.image = currAchievement.shareImage.image
                }
            }//eo-achievement
        }//eofl
    
    }//eom
    
    
    
    
    //MARK: -
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
