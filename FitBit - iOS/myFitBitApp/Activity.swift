//
//  Activity.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/11/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Acvitiy {
    
    fileprivate var _typeOfActivity:String
    fileprivate var _values:dateAndValue
    
    var typeOfActivity:String
        {
        return _typeOfActivity
    }
    
    var values:dateAndValue
        {
        return _values
    }
    
    convenience init(results:AnyObject)
    {
        self.init()
        
    }//eo-c
    
    init()
    {
        _typeOfActivity = ""
        _values = dateAndValue(date: "",value: "")
    }//eo-c
    
}//eoc

