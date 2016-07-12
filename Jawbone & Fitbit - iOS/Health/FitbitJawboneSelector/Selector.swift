//
//  Selector.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class Selector
{
    static let instance:Selector = Selector()
    
     let fitbitModel    = Fitbit.instance
     let jawboneModel   = Jawbone.instance
    
    var apiSelected:api = api(rawValue: 0)!
    
    
    var delegate:SelectorResponder?
    
    //MARK: - Constructor
    init()
    {
        self.getAPISelectionsFromDevice()
    }//eo-a
    
    
    //MARK: - Data from Device
    /**
    Method to update the property in the Selector class "apiSelected" which decides which track the OAuth process will 
    use to obtain an access Key. Fitbit or Jawbone.  This is applied prior to checking for a current accessToken.
    */
    private func getAPISelectionsFromDevice()
    {
        if NSUserDefaults.standardUserDefaults().isFitbitSelected() == true
        {
            self.apiSelected = api(rawValue: 1)!
        }
        else if NSUserDefaults.standardUserDefaults().isJawboneSelected() == true
        {
            self.apiSelected = api(rawValue: 2)!
        }
        else
        {
            self.apiSelected = api(rawValue: 0)!
        }
        
        print("apiSelected : \(apiSelected)")
    }//eom
    
    /**
    Method to take in selection from segmented controller and apply to VC property of the current VC.
    */
    func updateAPISelection(options:api)
    {
        self.apiSelected = options
        
        switch options
        {
            case .fitbit:
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Jawbone")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Fitbit")
                //
            break
            case .jawbone:
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Jawbone")
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Fitbit")
                //
            break
            case .none:
                NSUserDefaults.standardUserDefaults().removeObjectForKey("Jawbone")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("Fitbit")
            break
        }
        
        
    }//eom
    
    //MARK: - OAuth Status Delegate Process.
    func startUpServices()
    {
        /*
         Updating the FitBit / Jawbone to Delegate class.
        */
        self.fitbitModel.delegate   = delegate
        self.jawboneModel.delegate  = delegate
        switch(apiSelected.rawValue)
        {
            //jawbone
            case 2:
                self.jawboneModel.systemCheck(
                    { (allSystemGo, error) -> Void in
                    
                        if (allSystemGo == false)
                        {
                            self.delegate?.initialCheckResponse(false)
                        }
                        else
                        {
                            self.delegate?.initialCheckResponse(true)
                        }
                })
                break
            //fitbit
            case 1:
                self.fitbitModel.systemCheck(
                    { (allSystemGo, error) -> Void in
                    
                        if error != nil
                        {
                            self.delegate?.initialCheckResponse(false)
                        }
                        else
                        {
                            self.delegate?.initialCheckResponse(true)
                        }
                })
                break
            //none
            case 0:
                break
            default:
                break
        }
    }//eom
    
    //MARK: - Steps
    func getSteps(timeStart:stepsTimeStart, completion: (steps:[Step]?, error: NSError? ) -> Void)
    {
        switch(apiSelected.rawValue)
        {
            case 2:
                //checking system
                self.jawboneModel.systemCheck(
                { (allSystemGo, error) -> Void in
                    if allSystemGo
                    {
                        //getting steps
                        self.jawboneModel.getUserSteps(timeStart, completion:
                            { (steps, error) -> Void in
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(steps: steps, error: nil)
                                })
                        })
                    }
                    else
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                           completion(steps: nil, error: error)
                        })
                    }
                })
            break
            case 1:
                //checking system
                self.fitbitModel.systemCheck(
                { (allSystemGo, error) -> Void in
                    if error == nil
                    {
                        //getting steps
                        self.fitbitModel.getUserSteps(timeStart, completion:
                        { (steps, error) -> Void in
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completion(steps: steps, error: nil)
                            })
                        })
                    }
                    else
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completion(steps: nil, error: error)
                        })
                    }
                })
                break
            case 0:
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(steps: nil, error: noneOptionSelected)
                })
                break
            default:
                break
        }
    }//eom
    
    
    
}//eoc