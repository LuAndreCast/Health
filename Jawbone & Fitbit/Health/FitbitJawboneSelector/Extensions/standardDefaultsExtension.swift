//
//  standardDefaults.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation


extension NSUserDefaults
{

    //MARK: - API selection
    func isJawboneSelected()->Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isJawboneSaved:Bool = defaults.valueForKey("Jawbone") as? Bool
        {
            if isJawboneSaved
            {
                return true
            }
        }
        
        return false
    }//eom
    
    func isFitbitSelected()->Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isFitbitSaved:Bool = defaults.valueForKey("Fitbit") as? Bool
        {
            if isFitbitSaved
            {
                return true
            }
        }
        
        return false
    }//eom
    
    //MARK: -





}