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
    func setupAchievements(_ friendAchievements:NSArray)
    {
        for iter in 0..<friendAchievements.count
        {
            if let currAchievement:Achievement = friendAchievements .object(at: iter) as? Achievement
            {
                let currImageView:UIImageView = topBadgesImageView[iter]
                    currImageView.image = currAchievement.shareImage.image
                
            }//eo-achievement
        }//eofl
    
    }//eom
    
    
    
    
    //MARK: -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
