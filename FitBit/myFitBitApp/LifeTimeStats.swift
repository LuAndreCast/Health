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
    private var _bestDistance:dateAndValue
    private var _bestFloors:dateAndValue
    private var _bestSteps:dateAndValue
    
    private var _lifetimeDistance:String
    private var _lifetimeFloors:String
    private var _lifetimeSteps:String

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
            if let lifetimeDict:NSDictionary = resultDict .objectForKey("lifetime") as? NSDictionary
            {
                if let totalDict:NSDictionary = lifetimeDict .objectForKey("total") as? NSDictionary
                {
                    //distance
                    if let distance:Double = totalDict .objectForKey("distance") as? Double
                    {
                        _lifetimeDistance = "\(round(distance))"
                    }
                    
                    //floors
                    if let floors:Double = totalDict .objectForKey("floors") as? Double
                    {
                        _lifetimeFloors = "\(round(floors))"
                    }
                    
                    //steps
                    if let steps:Double = totalDict .objectForKey("steps") as? Double
                    {
                        _lifetimeSteps = "\(round(steps))"
                    }
                }//eo-total
            }//eo-total lifetime
            
            //best
            if let bestDict:NSDictionary = resultDict .objectForKey("best") as?NSDictionary
            {
                if let totalDict:NSDictionary = bestDict .objectForKey("total") as? NSDictionary
                {
                    //distance
                    if let distanceDict:NSDictionary = totalDict .objectForKey("distance") as? NSDictionary
                    {
                        //date
                        if let date:String = distanceDict .objectForKey("date") as? String ,
                           let value:Double = distanceDict .objectForKey("value") as? Double
                        {
                            _bestDistance = dateAndValue(date: date, value: "\(round(value))")
                        }
                    }//eo-best distance
                    
                    //floors
                    if let floorsDict:NSDictionary = totalDict .objectForKey("floors") as? NSDictionary
                    {
                        //date
                        if let date:String = floorsDict .objectForKey("date") as? String,
                            let value:Double = floorsDict .objectForKey("value") as? Double
                        {
                            _bestFloors = dateAndValue(date: date, value: "\(round(value))")
                        }
                    }//eo-best floors
                    
                    
                    //step
                    if let stepsDict:NSDictionary = totalDict .objectForKey("steps") as? NSDictionary
                    {
                        //date
                        if let date:String = stepsDict .objectForKey("date") as? String,
                           let value:Double = stepsDict .objectForKey("value") as? Double
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