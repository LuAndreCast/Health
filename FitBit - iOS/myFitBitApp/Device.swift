//
//  Device.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Device {

    fileprivate var _version:String
    fileprivate var _id:String
    fileprivate var _lastSync:String
    
    
    var version:String
        {
        return _version
    }
    
    var id:String
        {
        return _id
    }
    
    
    var lastSync:String
        {
        return _lastSync
    }
    
    convenience init(device:AnyObject)
    {
        self.init()
        
        if let deviceList:NSArray = device as? NSArray
        {
            if let deviceDict:NSDictionary = deviceList.firstObject as? NSDictionary
            {
                //device name
                if let deviceVersion:String = deviceDict .object(forKey: "deviceVersion") as? String
                {
                    _version = deviceVersion
                }
                
                //sync time
                if let deviceLastSync:String = deviceDict .object(forKey: "lastSyncTime") as? String
                {
                    _lastSync = deviceLastSync
                }
                
                //id
                if let deviceID:String = deviceDict .object(forKey: "id") as? String
                {
                    _id = deviceID
                }
            }//eo-device-dict
        }
    }//eo-c
    
    init()
    {
        _version = ""
        _id = ""
        _lastSync = ""
    }//eo-c
    
}//eoc

//
//{
//    battery = Medium;
//    deviceVersion = "Charge HR";
//    features =         (
//    );
//    id = 39910176;
//    lastSyncTime = "2016-03-08T22:22:15.000";
//    mac = 07EF99F976F0;
//    type = TRACKER;
//}
