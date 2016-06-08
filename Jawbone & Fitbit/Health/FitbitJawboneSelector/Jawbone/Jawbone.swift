//
//  Jawbone.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Jawbone:Oauth, codeResponder
{
    static let instance:Jawbone = Jawbone()
    
    private var urlSteps:String = ""
    private var urlUser:String  = ""
    
    //models
    let dateFormatter:DateFormatter = DateFormatter()
    
    //delegates
    var delegate:SelectorResponder?
    
    //MARK: - Constructors
    override init()
    {
        super.init()
        self.getDataFromDevice()
        
    }//eo-c
    
    //MARK: - Data on Device
    func getDataFromDevice()
    {
        //PLIST
        guard let pathOfFile:String = NSBundle .mainBundle() .pathForResource("Jawbone", ofType: "plist") else { return }
        
        guard let resourceDict:NSDictionary = NSDictionary(contentsOfFile: pathOfFile) else { return }
        
        //Oauth var's
        if let clientID:String = resourceDict .objectForKey("CLIENT_ID") as? String,
            let secret:String = resourceDict .objectForKey("SECRET_KEY") as? String,
            let redirectURI:String = resourceDict .objectForKey("REDIRECT_URI") as? String,
            let scope:String = resourceDict .objectForKey("SCOPE") as? String
        {
            self.clientID = clientID
            self.secretKey = secret
            self.redirect_uri = redirectURI
            self.scope = scope
        }
        
        if let authUrl:String = resourceDict .objectForKey("URL_AUTH") as? String
        {
            self.urlAuth = authUrl
        }
        
        
        if let tokenUrl:String = resourceDict .objectForKey("URL_TOKEN") as? String
        {
            self.urlToken = tokenUrl
        }
        
        if let stepsUrl:String = resourceDict .objectForKey("URL_STEPS") as? String
        {
            self.urlSteps = stepsUrl
        }
        
        if let userUrl:String = resourceDict .objectForKey("URL_USER") as? String
        {
            self.urlUser = userUrl
        }
        
        
        // access Credentials
        let defaults = NSUserDefaults.standardUserDefaults()
        do {
            let userData = try defaults.objectForKey(self.clientID) as? NSData
            if (userData != nil) {
                do {
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(userData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //access token
                    if let accessTokenRetrieved:String = jsonDictionary.objectForKey("access_token") as? String
                    {
                        self.accessToken = accessTokenRetrieved
                    }
                    
                    if let refreshTokenRetrieved:String = jsonDictionary.objectForKey("refresh_token") as? String
                    {
                        self.refreshToken = refreshTokenRetrieved
                    }
                    
                    if let codeExpirationRetrieved:String = jsonDictionary.objectForKey("expiration_date") as? String
                    {
                        self.codeExpiration = codeExpirationRetrieved
                    }
                } catch {
                    print (error)
                }
            }
        }
        
        self.debug()
    }//eom
    
    
    //MARK: - Checks
    func systemCheck( completion: (allSystemGo:Bool, error: NSError? ) -> Void)
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
                            completion(allSystemGo: true, error: nil)
                        }
                        else
                        {
                            completion(allSystemGo: false, error: error)
                        }
                })
            }
            //access codes are Good
            else
            {
                completion(allSystemGo: true, error: nil)
            }
        }
        else
        {
            completion (allSystemGo: false, error: nil)
        }
    }//eom
    
    
    
    
    
    //MARK: - Steps
    func getUserSteps(duration:stepsTimeStart, completion: (steps:[Step]?, error: NSError? ) -> Void)
    {
        var timeStart:Int = 0
        
        switch(duration)
        {
        case stepsTimeStart.thirty:
            timeStart = stepsTimeStart.thirty.rawValue * -1
            break
        case stepsTimeStart.ninety:
            timeStart = stepsTimeStart.ninety.rawValue * -1
            break
        case stepsTimeStart.halfYear:
            timeStart = stepsTimeStart.halfYear.rawValue * -1
            break
        case stepsTimeStart.year:
            timeStart = stepsTimeStart.year.rawValue * -1
            break
        }
        
        let timeStartString = DateFormatter.dateRewinder(timeStart)
        let stepBaseURL  = (self.urlSteps) .stringByAppendingString("start_time=\(timeStartString)")
        
        self.getUserData(stepBaseURL, completion:
            { (results, error) in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                    
                    completion(steps: nil, error: error)
                }
                else
                {
                    do
                    {
                        let steps = try Parser.jawbone_parseSteps(results)
                        completion(steps: steps, error: nil)
                    }
                    catch
                    {
                        completion(steps: nil, error: nil)
                    }
                }//some data
        })
    }//eom
    
    //MARK: - Oauth Auth Code Received
    func receiveAuthCode(dirtyCode: String)
    {
        //cleaning dirty code
        self.Webview_urlCodeCleanUp(dirtyCode)
        { (codeRetrieved) -> Void in
            
            if codeRetrieved == true
            {
                print("\n code: \(self.code) \n")
                //obtaining access token
                let accessTokenBody:NSMutableDictionary = self.createAccessTokenBody()
                self.getAccessToken(accessTokenBody, completion:
                    { (taskCompleted, error) -> Void in
                        
                        if taskCompleted == true
                        {
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.delegate?.finalCheckResponse(true)
                            })
                        }
                        else
                        {
                            print("error: \(error?.localizedDescription)")
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.delegate?.finalCheckResponse(false)
                            })
                        }
                })
            }
            else
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.delegate?.finalCheckResponse(false)
                })
            }
        }
    }//eom
    
    
    //MARK: - ParsingJSON
    private func parseJSON() throws {
        //        let jsonData =
        
        
        
    }
    
    //MARK: - Oauth Tokens
    private func createAccessTokenBody() -> NSMutableDictionary
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]    = "authorization_code"
        parameters["code"]          = self.code
        parameters["client_id"]     = self.clientID
        parameters["client_secret"] = self.secretKey
        
        return parameters
    }//eom
    
    private func createRefreshTokenBody() -> NSMutableDictionary
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["client_id"]     = self.clientID
        parameters["client_secret"] = self.secretKey
        parameters["grant_type"]    = "refresh_token"
        parameters["refresh_token"] = self.refreshToken
        
        return parameters
    }//eom
    
    
}//eoc