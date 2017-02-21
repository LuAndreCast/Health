//
//  Urls.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/7/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation


class Fitbit
{
    struct urls
    {
        var authorization:String
        var token:String
        var profile:String
        var friends:String
        var badges:String
        var devices:String
        var activities:String
        var lifetimestats:String
    }
    
    //the following need to be updated according to your app settings in fitbit.com
    fileprivate let _CLIENT_ID:String     = "ENTER_CLIENT_ID"
    fileprivate let _SECRET_KEY:String    = "ENTER_SECRET_KEY"
    fileprivate let _REDIRECT_URI:String  = "myFitBitApp://"
    
    //these are the scopes or user info you will like to have/query so you may not need all of these scopes
    fileprivate let _scope:String         = "activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight"
    fileprivate var _urls:urls
    
    var clientID:String
        {
            return _CLIENT_ID
    }
    
    
    var secretKey:String
        {
            return _SECRET_KEY
    }
    
    var redirectURI:String
        {
            return _REDIRECT_URI
    }
    
    var scope:String
        {
            return _scope
    }
    
    var url:urls
        {
        return _urls
    }
    
    var authCode:String      = ""
    var accessToken:String   = ""
    var refreshToken:String  = ""
    
    init()
    {
        _urls = urls(authorization: "https://www.fitbit.com/oauth2/authorize?",
                    token: "https://api.fitbit.com/oauth2/token",
                    profile: "https://api.fitbit.com/1/user/-/profile.json",
                    friends: "https://api.fitbit.com/1/user/-/friends.json",
                    badges: "https://api.fitbit.com/1/user/-/badges.json",
                    devices: "https://api.fitbit.com/1/user/-/devices.json",
                    activities: "https://api.fitbit.com/1/user/-/activities/",
                    lifetimestats: "https://api.fitbit.com/1/user/-/activities.json")
    }
    
    
    
   
}//eoc

