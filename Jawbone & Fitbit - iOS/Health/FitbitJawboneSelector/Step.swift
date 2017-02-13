//
//  Move.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Step
{
    fileprivate var _ID:Int?
    fileprivate var _date:Int
    fileprivate var _dateString:String
    fileprivate var _steps:String

    var dateInt:Int
        {
        return _date
    }
    
    var dateString:String
        {
        return _dateString
    }
    
    var steps:String
        {
        return _steps
    }
    
    
    //MARK: Constructors
    
    convenience init(theDate:Int, theSteps:String)
    {
        self.init()
    
        _date = theDate
        _steps = theSteps
    }//eo-c
    
    convenience init(theDate:String, theSteps:String)
    {
        self.init()
        
        _dateString = theDate
        _steps      = theSteps
    }//eo-c
    
    
    init ()
    {
        _ID         = nil
        _date       = 0
        _dateString = ""
        _steps      = ""
    }//eo-c
        
}//eoc
