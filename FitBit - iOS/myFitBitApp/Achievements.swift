//
//  Badges.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Achievements {
    
    fileprivate var _list:NSMutableArray
    
    var list:NSArray
        {
            return NSArray(array: _list)
    }
    
    convenience init(badges:AnyObject)
    {
        self.init()
        
        if let badgesList:NSArray = badges.object(forKey: "badges") as? NSArray
        {
            for currBadge in badgesList
            {
                if let badge:NSDictionary = currBadge as? NSDictionary
                {
                    let newAchievement:Achievement =  Achievement(dataDict: badge)
                    _list .add(newAchievement)
                }
            }//eofl
        }
    }//eo-c
    
    
    convenience init(topBadges:NSArray)
    {
        self.init()
        
        for currBadge in topBadges
        {
            if let badge:NSDictionary = currBadge as? NSDictionary
            {
                let newAchievement:Achievement =  Achievement(dataDict: badge)
                _list .add(newAchievement)
            }
        }//eofl
    }//eo-c
    
    init()
    {
        _list = NSMutableArray()
    }//eo-c
    

}
