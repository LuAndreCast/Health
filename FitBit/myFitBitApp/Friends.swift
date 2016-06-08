//
//  Friends.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation


class Friends
{
    private var _list:NSMutableArray
    
    var list:NSArray
        {
        return NSArray(array: _list)
    }
    
    convenience init(friends:AnyObject)
    {
        self.init()
    
        if let friendDict:NSDictionary = friends as? NSDictionary
        {
            if let friendList:NSArray = friendDict .objectForKey("friends") as? NSArray
            {
                for currFriend in friendList
                {
                    if let friendProfile:NSDictionary = currFriend as? NSDictionary
                    {
                        let newFriend:User = User(profile: friendProfile)
                        _list .addObject(newFriend)
                    }
                }//eofl
            }
        }
        
    }//eo-c
    
    init()
    {
        _list = NSMutableArray()
    }//eo-c
    
    
}