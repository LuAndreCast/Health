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
    fileprivate func getAPISelectionsFromDevice()
    {
        if UserDefaults.standard.isFitbitSelected() == true
        {
            self.apiSelected = api(rawValue: 1)!
        }
        else if UserDefaults.standard.isJawboneSelected() == true
        {
            self.apiSelected = api(rawValue: 2)!
        }
        else
        {
            self.apiSelected = api(rawValue: 0)!
        }
        
        print("apiSelected : \(apiSelected) \n\n")
    }//eom
    
    /**
    Method to take in selection from segmented controller and apply to VC property of the current VC.
    */
    func updateAPISelection(_ options:api)
    {
        self.apiSelected = options
        
        switch options
        {
            case .fitbit:
                UserDefaults.standard.set(false, forKey: "Jawbone")
                UserDefaults.standard.set(true, forKey: "Fitbit")
                //
            break
            case .jawbone:
                UserDefaults.standard.set(true, forKey: "Jawbone")
                UserDefaults.standard.set(false, forKey: "Fitbit")
                //
            break
            case .none:
                UserDefaults.standard.removeObject(forKey: "Jawbone")
                UserDefaults.standard.removeObject(forKey: "Fitbit")
                
                fitbitModel.signout()
                jawboneModel.signout()
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
    func getSteps(_ timeStart:stepsTimeStart, completion: @escaping (_ steps:[Step]?, _ error: NSError? ) -> Void)
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
                                OperationQueue.main.addOperation({ () -> Void in
                                    completion(steps, nil)
                                })
                        })
                    }
                    else
                    {
                        OperationQueue.main.addOperation({ () -> Void in
                           completion(nil, error)
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
                            OperationQueue.main.addOperation({ () -> Void in
                                completion(steps, nil)
                            })
                        })
                    }
                    else
                    {
                        OperationQueue.main.addOperation({ () -> Void in
                            completion(nil, error)
                        })
                    }
                })
                break
            case 0:
                OperationQueue.main.addOperation({ () -> Void in
                    completion(nil, noneOptionSelected)
                })
                break
            default:
                break
        }
    }//eom
    
    
    
}//eoc
