//
//  standardDefaults.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation


extension UserDefaults
{

    //MARK: - API selection
    func isJawboneSelected()->Bool
    {
        let defaults = UserDefaults.standard
        if let isJawboneSaved:Bool = defaults.value(forKey: "Jawbone") as? Bool
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
        let defaults = UserDefaults.standard
        if let isFitbitSaved:Bool = defaults.value(forKey: "Fitbit") as? Bool
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
