//
//  User.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class User
{
    
    private var _name:String
    private var _age:Int
    private var _dob:String
    private var _gender:String
    private var _userImage:Image
    private var _achievements:Achievements
    private var _memberSince:String
    //
    private var _height:String
    private var _timezone:String
    
    
    var name:String
        {
        return _name
    }
    
    var age:Int
        {
            return _age
    }
    
    
    var dob:String
        {
            return _dob
    }
    
    var gender:String
        {
            return _gender
    }

    var profileImage:Image
        {
            return _userImage
    }
    
    var achievements:Achievements
        {
        return _achievements
    }
    
    var memberSince:String
        {
            return _memberSince
    }
    
    convenience init(profile:AnyObject)
    {
        self.init()
        
        
        if let profileResults = profile as? NSDictionary
        {
            if let userProfile:NSDictionary = profileResults .objectForKey("user") as? NSDictionary
            {
                //user image
                if let avatarUrlString:String = userProfile .objectForKey("avatar150") as? String
                {
                    _userImage = Image(imageUrl: avatarUrlString)
                }
                
                //name
                if let fullName:String = userProfile .objectForKey("fullName") as? String where fullName != ""
                {
                    _name = fullName
                }
                else if let displayName:String = userProfile .objectForKey("displayName") as? String where displayName != ""
                {
                    _name = displayName
                }
                else if let nickname:String = userProfile .objectForKey("nickname") as? String where nickname != ""
                {
                    _name = nickname
                }
                
                //age
                if let age:Int  = userProfile .objectForKey("age") as? Int
                {
                    _age = age
                }
                
                //dob
                if let dob:String   = userProfile .objectForKey("dateOfBirth") as? String
                {
                    _dob = dob
                }
                
                //gender
                if let gender:String    = userProfile .objectForKey("gender") as? String
                {
                    _gender = gender
                }
                
                //topBadges
                if let topBadges:NSArray = userProfile .objectForKey("topBadges") as? NSArray
                {
                    _achievements = Achievements(topBadges: topBadges)
                }
                
                //memberSince
                if let memberSince:String = userProfile .objectForKey("memberSince") as? String
                {
                    _memberSince = memberSince
                }
            }//eo-results
        }//eom

    }//eo-c
    
    
    init()
    {
        _name = ""
        _age = 0
        _dob = ""
        _gender = ""
        _userImage = Image()
        _memberSince = ""
        _height = ""
        _timezone = ""
        _achievements = Achievements()
        
    }//eo-c
    
    
    
}//eoc

