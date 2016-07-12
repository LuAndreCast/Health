//
//  storage.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/12/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Storage {
    
    static let permanent = Storage()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    init()
    {
        
    }
    
    //MARK: - Saving/Retrieve Data from Device
    func saveDataOnDevice(code:String, refreshToken:String)
    {
        defaults .setBool(true, forKey: "save")
        defaults .setObject(code, forKey: "code")
        defaults .setObject(refreshToken, forKey: "refreshToken")
        defaults.synchronize()
    }//eom
    
    func retrievedDataFromDevice()->NSDictionary?
    {
        let codeSaved:Bool = defaults .boolForKey("save")
        if codeSaved
        {
            if let codeString:String = defaults .objectForKey("code") as? String where codeString != "",
                let refreshTokenString:String = defaults .objectForKey("refreshToken") as? String where refreshTokenString != ""
            {
                let keys    = ["code", "refreshToken"]
                let values  = [codeString, refreshTokenString]
                return NSDictionary(objects: keys , forKeys: values)
            }
        }//eo-saved values
        
        return nil
    }//eom
    
    func deleteDataFromDevice()
    {
        defaults.removeObjectForKey("save")
        defaults.removeObjectForKey("code")
        defaults.removeObjectForKey("refreshToken")
        defaults.synchronize()
    }//eom
    

    

}//eoc