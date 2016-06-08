//
//  Oauth.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Oauth {
    
    static let Oauth2 = Oauth()
    
    //private let fitbit = FitBitAPI.model
    let fitbit = FitBitAPI.model //temp for now
    
    private let permanentStorage = Storage.permanent
    
    init()
    {
    
    
    }

    
    
    //MARK: - Authorization Request
    
    /* returns true when data is retrieved from permant storage */
    func requestAuthorization(option:String)->Bool
    {
        if let dataSaved:NSDictionary = self.permanentStorage.retrievedDataFromDevice()
        {
            if let code:String = dataSaved .objectForKey("code") as? String,
            let refreshToken:String = dataSaved .objectForKey("refreshToken") as? String
            {
                switch(option)
                {
                    case "fitbit":
                        fitbit.authCode     = code
                        fitbit.refreshToken = refreshToken
                        break
                    default:
                        break
                }
            }
            
            return true
        }//eo-retrieved data
        
        
        var urlToRequest:String = ""
        switch(option)
        {
            case "fitbit":
            urlToRequest = fitbit.getAuthString()
            self.makeRequestThruSafari(urlToRequest)
                break
            default:
                break
        }//eo-url request
        
        return false
    }//eom
    
    private func makeRequestThruSafari(url:String)
    {
        if let finalUrl:NSURL = NSURL(string: url)
        {
            print("\n \(finalUrl)")
            UIApplication .sharedApplication() .openURL(finalUrl)
        }
    }//eom
    
    func handleAuthorizationResponce(responce:[NSObject: AnyObject])->Bool
    {
        if let dirtyCode:String = responce["code"] as? String
        {
            let code = self.processCodeFromUrl(dirtyCode)
            if ( code != nil)
            {
               //adjust later
                fitbit.authCode = code!
                
                return true
            }
        }
        
        return false
    }//eom
    
    //MARK: Gets auth code from url
    func processCodeFromUrl(dirtyCode:String)->String?
    {
        if dirtyCode.containsString("myfitbitapp://?code=") && dirtyCode.containsString("#")
        {
            var cleanCode:String = dirtyCode.stringByReplacingOccurrencesOfString("myfitbitapp://?code=", withString: "")
            
            let lists:[String] = cleanCode.componentsSeparatedByString("#")
            
            cleanCode = lists[0]
            
            return cleanCode
        }
        
        
        
//        var cleanCode:NSString?
//        var needToRemove:NSString?
//        var cleanCodeKey:NSString?
//        var cleanCodeValue:NSString?
//        
//        let startValuesSeperator:String = "?"
//        let keyValueSeparator:String    = "&"
//        let elementSeparator:String     = "="
//        
//        var scanner:NSScanner = NSScanner(string: dirtyCode)
//        
//        //cleaning Values And Keys
//        needToRemove = nil
//        cleanCode = nil
//        scanner.scanUpToString(startValuesSeperator, intoString: &needToRemove)
//        scanner.scanUpToString("", intoString: &cleanCode)
//        scanner.scanString(startValuesSeperator, intoString: nil)
//        
//        let temp:String =  cleanCode as! String
//        cleanCode =  String(temp.characters.dropFirst(1))
//        
//        var keysAndValues:Dictionary<String, String> =  Dictionary<String, String>()
//        
//        //seperating values and keys
//        scanner = NSScanner(string: cleanCode as! String)
//        while( scanner .atEnd == false )
//        {
//            //Key
//            cleanCodeValue = nil
//            scanner.scanUpToString(elementSeparator, intoString: &cleanCodeKey)
//            scanner.scanString(elementSeparator, intoString: nil)
//            
//            //value
//            cleanCodeValue = nil
//            scanner.scanUpToString(keyValueSeparator, intoString: &cleanCodeValue)
//            scanner.scanString(keyValueSeparator, intoString: nil)
//            
//            if ( cleanCodeKey?.length > 0 ) && ( cleanCodeValue?.length > 0 )
//            {
//                keysAndValues.updateValue(cleanCodeValue as! String, forKey: cleanCodeKey as! String)
//            }
//        }//eowl
//        
//        if let code:String = keysAndValues["code"]
//        {
//            return code
//        }

        return nil
    }//eom
    
    //MARK: - Create Header for Basic Autherization
    private func createBasicAuthHeaderString(clientID:String, secretKey:String)->String
    {
        let headerString:String = "\(clientID):\(secretKey)"
        let headerData:NSData   = headerString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64HeaderString  = headerData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

        return base64HeaderString
    }//eom

    
    //MARK: - Access Token Request
    func requestAccessToken(option:String, completion: ((accessTokenRetrieved: Bool?, error: NSError? ) -> Void))
    {
        var url:String          = ""
        var redirect_uri:String = ""
        var code:String         = ""
        var clientID:String     = ""
        var secretKey:String    = ""
        
        switch(option)
        {
            case "fitbit":
                url             = fitbit.url.token
                redirect_uri    = fitbit.redirectURI
                code            = fitbit.authCode
                clientID        = fitbit.clientID
                secretKey       = fitbit.secretKey
                
                break
            default:
                break
        }
        
        
        //url
        if let url:NSURL = NSURL(string: url)
        {
            print("\n \(url)")
            
            //request
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            //request type
            request.HTTPMethod = "POST"
            
            //request header
            let headerString  = createBasicAuthHeaderString(clientID, secretKey: secretKey)
            
            request.setValue("Basic \(headerString)", forHTTPHeaderField: "Authorization")
            
            //request body
            do
            {
                //set body format
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                //adding body
                request.HTTPBody = createdAccessTokenRequestBody(redirect_uri, code: code, client_id: clientID)
            }
            catch
            {
                print("could not add data to body")
            }
            
            //request task
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
                { (data, response, error) in
                    
                    if error != nil
                    {
                        print("error \(error?.localizedDescription)")
                        completion(accessTokenRetrieved: false, error: error)
                    }
                    else
                    {
                        if let responseData = data
                        {
                            do{
                                let jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                                
                                print("tokens: \(jsonResult)")
                                
                                //saving token data
                                if let resultsDict:NSDictionary = jsonResult as? NSDictionary
                                {
                                    //errors
                                    if let errorsDict = resultsDict .objectForKey("errors")
                                    {
                                        print("\n\n errors: \(errorsDict)")
                                        self.permanentStorage.deleteDataFromDevice()
                                        completion(accessTokenRetrieved: false, error: nil)
                                    }
                                    
                                    
                                    //access token & refresh token
                                    if let accessToken:String = resultsDict .objectForKey("access_token") as? String where accessToken != "",
                                        let refreshToken:String = resultsDict .objectForKey("refresh_token") as? String where refreshToken != ""
                                    {
                                        switch(option)
                                        {
                                            case "fitbit":
                                                
                                                //update model
                                                self.fitbit.accessToken = accessToken
                                                self.fitbit.refreshToken = refreshToken
                                                
                                                //save on device
                                                self.permanentStorage.saveDataOnDevice(self.fitbit.authCode, refreshToken: refreshToken)
                                                
                                                completion(accessTokenRetrieved: true, error: nil)
                                                break
                                            default:
                                                completion(accessTokenRetrieved: false, error: nil)
                                                break
                                        }//eo-switch
                                    }
                                    else
                                    {
                                        completion(accessTokenRetrieved: false, error: nil)
                                    }
                                }
                                else
                                {
                                    print("un-able to get Dict")
                                    completion(accessTokenRetrieved: false, error: nil)
                                }
                            }
                            catch
                            {
                                print("could not serialize data\n")
                                completion(accessTokenRetrieved: false, error: nil)
                            }
                        }
                    }
                    
                    completion(accessTokenRetrieved: false, error: error)
            })
            task.resume()
        }
        else
        {
            let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
            completion(accessTokenRetrieved: false, error: error)
        }
    }//eom
   
    
    //MARK:  Access Token Body Builder
    private func createdAccessTokenRequestBody(redirect_uri:String, code:String, client_id:String)->NSData?
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]            = "authorization_code"
        parameters["redirect_uri"]          = redirect_uri
        parameters["code"]                  = code
        parameters["client_id"]             = client_id
        
        
        var addedFirstKey:Bool = false
        var bodyString:NSString = ""
        let paramKeys = parameters.allKeys
        for currKey in paramKeys
        {
            guard let currValue:String = parameters .objectForKey(currKey) as? String else { continue }
            
            if addedFirstKey == false
            {
                let stringToAdd = "\(currKey)=\(currValue)"
                bodyString = bodyString .stringByAppendingString(stringToAdd)
                
                addedFirstKey = true
            }
            else
            {
                let stringToAdd = "&\(currKey)=\(currValue)"
                bodyString = bodyString .stringByAppendingString(stringToAdd)
                
            }
        }//eofl
        
        if let bodyStringData:NSData = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            return bodyStringData
        }
        
        return nil
    }//eom

    
   
    
    
    //MARK:  Refresh Token Body Builder
    private func createdRefreshTokenRequestBody(refresh_token:String)->NSData?
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]            = "refresh_token"
        parameters["refresh_token"]         = refresh_token
        
        var addedFirstKey:Bool = false
        var bodyString:NSString = ""
        let paramKeys = parameters.allKeys
        for currKey in paramKeys
        {
            guard let currValue:String = parameters .objectForKey(currKey) as? String else { continue }
            
            if addedFirstKey == false
            {
                let stringToAdd = "\(currKey)=\(currValue)"
                bodyString = bodyString .stringByAppendingString(stringToAdd)
                
                addedFirstKey = true
            }
            else
            {
                let stringToAdd = "&\(currKey)=\(currValue)"
                bodyString = bodyString .stringByAppendingString(stringToAdd)
                
            }
        }//eofl
        
        if let bodyStringData:NSData = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            return bodyStringData
        }
        
        return nil
    }//eom
    
 //MARK: - Refresh Token Request
    func requestRefreshToken(option:String, completion: ((accessTokenRetrieved: Bool?, error: NSError? ) -> Void))
    {
    
    var url:String              = ""
    var clientID:String         = ""
    var secretKey:String        = ""
    var refreshToken:String     = ""
    
    
    switch(option)
    {
        case "fitbit":
            url             = fitbit.url.token
            clientID        = fitbit.clientID
            secretKey       = fitbit.secretKey
            refreshToken     = fitbit.refreshToken
            
            break
        default:
            break
    }

    //url
    if let url:NSURL = NSURL(string: url)
    {
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        //request type
        request.HTTPMethod = "POST"
        
        //request header
        let headerString  = createBasicAuthHeaderString(clientID, secretKey: secretKey)
        
        request.setValue("Basic \(headerString)", forHTTPHeaderField: "Authorization")
        
        //request body
        do
        {
            //set body format
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            //adding body
            request.HTTPBody = createdRefreshTokenRequestBody(refreshToken)
        }
        catch
        {
            print("could not add data to body")
        }
        
        //request task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
        { (data, response, error) in
           
            if error != nil
            {
                print("error \(error?.localizedDescription)")
                completion(accessTokenRetrieved: false, error: error)
            }
            else
            {
                if let responseData = data
                {
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)

                        print("tokens: \(jsonResult)")

                            //saving token data
                            if let resultsDict:NSDictionary = jsonResult as? NSDictionary
                            {
                                //errors
                                if let errorsDict = resultsDict .objectForKey("errors")
                                {
                                    print("\n\n errors: \(errorsDict)")
                                    self.permanentStorage.deleteDataFromDevice()
                                    completion(accessTokenRetrieved: false, error: nil)
                                }
                                
                                
                                //access token & refresh token
                                if let accessToken:String = resultsDict .objectForKey("access_token") as? String where accessToken != "",
                                    let refreshToken:String = resultsDict .objectForKey("refresh_token") as? String where refreshToken != ""
                                {
                                    switch(option)
                                    {
                                        case "fitbit":
                                            //update model
                                            self.fitbit.accessToken = accessToken
                                            self.fitbit.refreshToken = refreshToken
                                            
                                            //save on device
                                            self.permanentStorage.saveDataOnDevice(self.fitbit.authCode, refreshToken: refreshToken)
                                            
                                            completion(accessTokenRetrieved: true, error: nil)
                                            break
                                        default:
                                            completion(accessTokenRetrieved: false, error: nil)
                                            break
                                    }
                                }
                                else
                                {
                                    completion(accessTokenRetrieved: false, error: nil)
                                }
                            }
                            else
                            {
                                print("un-able to get Dict")
                                completion(accessTokenRetrieved: false, error: nil)
                            }
                        }
                        catch
                        {
                            print("could not serialize data\n")
                            completion(accessTokenRetrieved: false, error: nil)
                        }
                    
                }//eo-data
            }//eo-else
             completion(accessTokenRetrieved: false, error: error)
        })
        task.resume()
    }
    else
    {
        let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
        completion(accessTokenRetrieved: false, error: error)
    }
}//eom

    
    
    
    
}//eoc






