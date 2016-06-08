//
//  Badge.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Achievement {
    
    
    private var _backgroundColor:Color
    private var _image300:Image
    private var _image125:Image
    private var _shareImage:Image
    private var _description:String
    private var _mobileDescription:String
    private var _shortName:String
    private var _category:String
    private var _dateTime:String
    
    
    var shareImage:Image
        {
        return _shareImage
    }
    
    var image300:Image
        {
            return _image300
    }
    
    var image125:Image
        {
            return _image125
    }
    
    var backgroundColor:Color
        {
            return _backgroundColor
    }
    
    var description:String
        {
            return _description
    }
    
    var shortname:String
        {
        return _shortName
    }
    
    var mobileDescription:String
        {
            return _mobileDescription
    }
    
    var dateTime:String
        {
            return _dateTime
    }
    
    
    var category:String
        {
            return _category
    }
    
    convenience init(dataDict:NSDictionary)
    {
        self.init()
        
        //share image
        if let topBadgeImageUrlString:String = dataDict .objectForKey("shareImage640px") as? String
        {
            _shareImage = Image(imageUrl: topBadgeImageUrlString)
        }
        
        //image  - 125
        if let badgeImage:String = dataDict .objectForKey("image125px") as? String
        {
            _image125 = Image(imageUrl: badgeImage)
        }
        
        //image - 300
        if let badgeImage:String = dataDict .objectForKey("image300px") as? String
        {
            _image300 = Image(imageUrl: badgeImage)
        }
        
       
        
        //color
        if let badgeColor:String = dataDict .objectForKey("badgeGradientStartColor") as? String
        {
            _backgroundColor = Color(colorInHex: badgeColor)
        }
        
        //description
        if let badgeDescription:String = dataDict .objectForKey("description") as? String
        {
            _description = badgeDescription
        }
        
        //shortName
        if let shortName:String = dataDict .objectForKey("shortName") as? String
        {
            _shortName = shortName
        }
        
        
        //mobile Description
        if let badgeMobileDescription:String = dataDict .objectForKey("mobileDescription") as? String
        {
            _mobileDescription = badgeMobileDescription
        }
        
        //dateTime
        if let badgeDateTime:String = dataDict .objectForKey("dateTime") as? String
        {
            _dateTime = badgeDateTime
        }
        
        //category
        if let badgeCategory:String = dataDict .objectForKey("category") as? String
        {
            _category = badgeCategory
        }
        
        
    }//eo-c
    
    
    
    init()
    {
        _shareImage  = Image()
        _image300  = Image()
        _image125 = Image()
        _backgroundColor  = Color()
        _description = ""
        _shortName = ""
        _mobileDescription = ""
        _category  = ""
        _dateTime  = ""
    
    }//eo-c
    
}//eoc
