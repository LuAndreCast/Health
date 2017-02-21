//
//  LifeTimeStats.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation



class LifeTimeStats
{
    fileprivate var _bestDistance:dateAndValue
    fileprivate var _bestFloors:dateAndValue
    fileprivate var _bestSteps:dateAndValue
    
    fileprivate var _lifetimeDistance:String
    fileprivate var _lifetimeFloors:String
    fileprivate var _lifetimeSteps:String

    var bestDistance:dateAndValue
        {
    
        return _bestDistance
    }
    
    var bestFloors:dateAndValue
        {
        return _bestFloors
    }
    
    var bestSteps:dateAndValue
        {
        return _bestSteps
    }
    
    var lifetimeDistance:String
        {
            
            return _lifetimeDistance
    }
    
    var lifetimeFloors:String
        {
            return _lifetimeFloors
    }
    
    var lifetimeSteps:String
        {
            return _lifetimeSteps
    }
    
    convenience init(results:AnyObject)
    {
        self.init()
        
        
        if let resultDict:NSDictionary = results as? NSDictionary
        {
            //total
            if let lifetimeDict:NSDictionary = resultDict .object(forKey: "lifetime") as? NSDictionary
            {
                if let totalDict:NSDictionary = lifetimeDict .object(forKey: "total") as? NSDictionary
                {
                    //distance
                    if let distance:Double = totalDict .object(forKey: "distance") as? Double
                    {
                        _lifetimeDistance = "\(round(distance))"
                    }
                    
                    //floors
                    if let floors:Double = totalDict .object(forKey: "floors") as? Double
                    {
                        _lifetimeFloors = "\(round(floors))"
                    }
                    
                    //steps
                    if let steps:Double = totalDict .object(forKey: "steps") as? Double
                    {
                        _lifetimeSteps = "\(round(steps))"
                    }
                }//eo-total
            }//eo-total lifetime
            
            //best
            if let bestDict:NSDictionary = resultDict .object(forKey: "best") as?NSDictionary
            {
                if let totalDict:NSDictionary = bestDict .object(forKey: "total") as? NSDictionary
                {
                    //distance
                    if let distanceDict:NSDictionary = totalDict .object(forKey: "distance") as? NSDictionary
                    {
                        //date
                        if let date:String = distanceDict .object(forKey: "date") as? String ,
                           let value:Double = distanceDict .object(forKey: "value") as? Double
                        {
                            _bestDistance = dateAndValue(date: date, value: "\(round(value))")
                        }
                    }//eo-best distance
                    
                    //floors
                    if let floorsDict:NSDictionary = totalDict .object(forKey: "floors") as? NSDictionary
                    {
                        //date
                        if let date:String = floorsDict .object(forKey: "date") as? String,
                            let value:Double = floorsDict .object(forKey: "value") as? Double
                        {
                            _bestFloors = dateAndValue(date: date, value: "\(round(value))")
                        }
                    }//eo-best floors
                    
                    
                    //step
                    if let stepsDict:NSDictionary = totalDict .object(forKey: "steps") as? NSDictionary
                    {
                        //date
                        if let date:String = stepsDict .object(forKey: "date") as? String,
                           let value:Double = stepsDict .object(forKey: "value") as? Double
                        {
                            _bestSteps = dateAndValue(date: date, value: "\(round(value))")
                        }
                    }//eo- best step
                    
                }//eo-total
            }//eo-best
        }//eo-valid responce
    }//eo-c
    
    
    init()
    {
        _bestDistance   = dateAndValue(date: "", value: "")
        _bestSteps      = dateAndValue(date: "", value: "")
        _bestFloors     = dateAndValue(date: "", value: "")
        
        _lifetimeDistance   = String()
        _lifetimeSteps      = String()
        _lifetimeFloors     = String()
    }//eo-c
    
}
