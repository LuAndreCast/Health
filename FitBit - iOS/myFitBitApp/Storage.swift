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
    
    fileprivate let defaults = UserDefaults.standard
    
    init()
    {
        
    }
    
    //MARK: - Saving/Retrieve Data from Device
    func saveDataOnDevice(_ code:String, refreshToken:String)
    {
        defaults .set(true, forKey: "save")
        defaults .set(code, forKey: "code")
        defaults .set(refreshToken, forKey: "refreshToken")
        defaults.synchronize()
    }//eom
    
    func retrievedDataFromDevice()->NSDictionary?
    {
        let codeSaved:Bool = defaults .bool(forKey: "save")
        if codeSaved
        {
            if let codeString:String = defaults .object(forKey: "code") as? String, codeString != "",
                let refreshTokenString:String = defaults .object(forKey: "refreshToken") as? String, refreshTokenString != ""
            {
                let keys    = ["code", "refreshToken"]
                let values  = [codeString, refreshTokenString]
                return NSDictionary(objects: keys , forKeys: values as [NSCopying])
            }
        }//eo-saved values
        
        return nil
    }//eom
    
    func deleteDataFromDevice()
    {
        defaults.removeObject(forKey: "save")
        defaults.removeObject(forKey: "code")
        defaults.removeObject(forKey: "refreshToken")
        defaults.synchronize()
    }//eom
    

    

}//eoc
