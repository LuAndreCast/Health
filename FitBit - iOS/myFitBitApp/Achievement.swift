//
//  Badge.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Achievement {
    
    
    fileprivate var _backgroundColor:Color
    fileprivate var _image300:Image
    fileprivate var _image125:Image
    fileprivate var _shareImage:Image
    fileprivate var _description:String
    fileprivate var _mobileDescription:String
    fileprivate var _shortName:String
    fileprivate var _category:String
    fileprivate var _dateTime:String
    
    
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
        if let topBadgeImageUrlString:String = dataDict .object(forKey: "shareImage640px") as? String
        {
            _shareImage = Image(imageUrl: topBadgeImageUrlString)
        }
        
        //image  - 125
        if let badgeImage:String = dataDict .object(forKey: "image125px") as? String
        {
            _image125 = Image(imageUrl: badgeImage)
        }
        
        //image - 300
        if let badgeImage:String = dataDict .object(forKey: "image300px") as? String
        {
            _image300 = Image(imageUrl: badgeImage)
        }
        
       
        
        //color
        if let badgeColor:String = dataDict .object(forKey: "badgeGradientStartColor") as? String
        {
            _backgroundColor = Color(colorInHex: badgeColor)
        }
        
        //description
        if let badgeDescription:String = dataDict .object(forKey: "description") as? String
        {
            _description = badgeDescription
        }
        
        //shortName
        if let shortName:String = dataDict .object(forKey: "shortName") as? String
        {
            _shortName = shortName
        }
        
        
        //mobile Description
        if let badgeMobileDescription:String = dataDict .object(forKey: "mobileDescription") as? String
        {
            _mobileDescription = badgeMobileDescription
        }
        
        //dateTime
        if let badgeDateTime:String = dataDict .object(forKey: "dateTime") as? String
        {
            _dateTime = badgeDateTime
        }
        
        //category
        if let badgeCategory:String = dataDict .object(forKey: "category") as? String
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
