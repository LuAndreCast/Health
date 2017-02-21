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
    
    fileprivate var _name:String
    fileprivate var _age:Int
    fileprivate var _dob:String
    fileprivate var _gender:String
    fileprivate var _userImage:Image
    fileprivate var _achievements:Achievements
    fileprivate var _memberSince:String
    //
    fileprivate var _height:String
    fileprivate var _timezone:String
    
    
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
            if let userProfile:NSDictionary = profileResults .object(forKey: "user") as? NSDictionary
            {
                //user image
                if let avatarUrlString:String = userProfile .object(forKey: "avatar150") as? String
                {
                    _userImage = Image(imageUrl: avatarUrlString)
                }
                
                //name
                if let fullName:String = userProfile .object(forKey: "fullName") as? String, fullName != ""
                {
                    _name = fullName
                }
                else if let displayName:String = userProfile .object(forKey: "displayName") as? String, displayName != ""
                {
                    _name = displayName
                }
                else if let nickname:String = userProfile .object(forKey: "nickname") as? String, nickname != ""
                {
                    _name = nickname
                }
                
                //age
                if let age:Int  = userProfile .object(forKey: "age") as? Int
                {
                    _age = age
                }
                
                //dob
                if let dob:String   = userProfile .object(forKey: "dateOfBirth") as? String
                {
                    _dob = dob
                }
                
                //gender
                if let gender:String    = userProfile .object(forKey: "gender") as? String
                {
                    _gender = gender
                }
                
                //topBadges
                if let topBadges:NSArray = userProfile .object(forKey: "topBadges") as? NSArray
                {
                    _achievements = Achievements(topBadges: topBadges)
                }
                
                //memberSince
                if let memberSince:String = userProfile .object(forKey: "memberSince") as? String
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

