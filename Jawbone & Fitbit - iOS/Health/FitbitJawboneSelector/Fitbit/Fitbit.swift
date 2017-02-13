//
//  Fitbit.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Fitbit: Oauth, codeResponder
{
    static let instance:Fitbit = Fitbit()
    
    fileprivate var urlSteps:String = ""
    fileprivate var urlUser:String  = ""
    
    //models
    fileprivate let dateFormatter:DateFormatter = DateFormatter()
    
    //delegates
    var delegate:SelectorResponder?
    
    //MARK: - Constructors
    override init()
    {
        super.init()
        
        self.getDataFromDevice()
        
    }//eo-c
    
    //MARK: - Data on Device
    fileprivate func getDataFromDevice()
    {
        let defaults = UserDefaults.standard
    
        
        //PLIST
        guard let pathOfFile:String = Bundle.main .path(forResource: "Fitbit", ofType: "plist") else { return }
        
        guard let resourceDict:NSDictionary = NSDictionary(contentsOfFile: pathOfFile) else { return }
        
        //Oauth var's
        if let clientID:String = resourceDict .object(forKey: "CLIENT_ID") as? String,
            let secret:String = resourceDict .object(forKey: "SECRET_KEY") as? String,
            let redirectURI:String = resourceDict .object(forKey: "REDIRECT_URI") as? String,
            let scope:String = resourceDict .object(forKey: "SCOPE") as? String
        {
            self.clientID = clientID
            self.secretKey = secret
            self.redirect_uri = redirectURI
            self.scope = scope
        }
        
        if let authUrl:String = resourceDict .object(forKey: "URL_AUTH") as? String
        {
            self.urlAuth = authUrl
        }
        
        if let tokenUrl:String = resourceDict .object(forKey: "URL_TOKEN") as? String
        {
            self.urlToken = tokenUrl
        }
        
        if let stepsUrl:String = resourceDict .object(forKey: "URL_STEPS") as? String
        {
            self.urlSteps = stepsUrl
        }
        
        if let userUrl:String = resourceDict .object(forKey: "URL_USER") as? String
        {
            self.urlUser = userUrl
        }
        
        ////////////////////          ////////////////////   
        
        do
        {
            let userData = defaults.object(forKey: self.clientID) as? Data
            if (userData != nil)
            {
                let jsonDictionary = try JSONSerialization.jsonObject(with: userData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //access token
                if let accessTokenRetrieved:String = jsonDictionary.object(forKey: "access_token") as? String
                {
                    self.accessToken = accessTokenRetrieved
                }
                
                if let refreshTokenRetrieved:String = jsonDictionary.object(forKey: "refresh_token") as? String
                {
                    self.refreshToken = refreshTokenRetrieved
                }
                
                if let codeExpirationRetrieved:String = jsonDictionary.object(forKey: "expiration_date") as? String
                {
                    self.codeExpiration = codeExpirationRetrieved
                }
            
            }
        }
        catch {
            print (error)
        }
        
        
        
        // self.debug()
    }//eom
    
    
     //MARK: - Checks
    func systemCheck( _ completion: @escaping (_ allSystemGo:Bool, _ error: NSError? ) -> Void)
    {
        //we have a token
        if self.accessToken.characters.count > 0
        {
            //is it valid? - check expiration!
            if dateFormatter.isCodeExpired(self.codeExpiration)
            {
                //get new codes
                let body:NSMutableDictionary = self.createRefreshTokenBody()
                self.getAccessToken(body, completion:
                    { (taskCompleted, error) in
                        if taskCompleted == true
                        {
                            completion(true, nil)
                        }
                        else
                        {
                            completion(false, error)
                        }
                })
            }
            //access codes are Good
            else
            {
                completion(true, nil)
            }
        }
        else
        {
            self.getSafariAuth(
                { (safariCalled, error) -> Void in
                    
                    completion(safariCalled, error)
                    
                })
        }
    }//eom
    
    
    
    //MARK: - Steps
    func getUserSteps(_ duration:stepsTimeStart, completion: @escaping (_ steps:[Step]?, _ error: NSError? ) -> Void)
    {
        var stepBaseURL:String  = self.urlSteps
        
        switch(duration)
        {
            case stepsTimeStart.thirty:
                stepBaseURL  = "\(stepBaseURL)/30d.json"
                break
            case stepsTimeStart.ninety:
                stepBaseURL  = "\(stepBaseURL)/3m.json"
                break
            case stepsTimeStart.halfYear:
                stepBaseURL  = "\(stepBaseURL)/6m.json"
                break
            case stepsTimeStart.year:
                stepBaseURL  = "\(stepBaseURL)/1y.json"
                break
        }
        
        
        self.getUserData(stepBaseURL, completion:
            { (results, error) in
                
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                    
                    completion(nil, error)
                }
                else
                {
                    do
                    {
                        let steps = try Parser.fitbit_parseSteps(results)
                        completion(steps, nil)
                    }
                    catch
                    {
                        completion(nil, nil)
                    }
            }//eo-some data
        })
    }//eom
    
    //MARK: - Oauth Auth Code Received
    func receiveAuthCode(_ dirtyCode: String)
    {
        //cleaning dirty code
        self.Safari_urlCodeCleanUp(dirtyCode)
            { (codeRetrieved) -> Void in
            
            if codeRetrieved == true
            {
                //obtaining access token
                let accessTokenBody:NSMutableDictionary = self.createAccessTokenBody()
                self.getAccessToken(accessTokenBody, completion:
                    { (taskCompleted, error) -> Void in
                   
                        if taskCompleted == true
                        {
                            OperationQueue.main.addOperation({ () -> Void in
                                    self.delegate?.finalCheckResponse(true, nil)
                                })
                        }
                        else
                        {
                            print("error: \(error?.localizedDescription)")
                            
                            OperationQueue.main.addOperation({ () -> Void in
                                self.delegate?.finalCheckResponse(false, error)
                            })
                        }
                })
            }
            else
            {
                OperationQueue.main.addOperation({ () -> Void in
                    self.delegate?.finalCheckResponse(false, nil)
                })
            }
        }
    }//eom
    
    
    //MARK: - Oauth Tokens
    fileprivate func createAccessTokenBody() -> NSMutableDictionary
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]    = "authorization_code"
        parameters["code"]          = self.code
        parameters["client_id"]     = self.clientID
        parameters["redirect_uri"]  = self.redirect_uri
        
        return parameters
    }//eom
    
    fileprivate func createRefreshTokenBody() -> NSMutableDictionary
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]    = "refresh_token"
        parameters["refresh_token"] = self.refreshToken

        return parameters
    }//eom

    func signout()
    {
        self.clearAuthData()
    }
    
}//eoc
