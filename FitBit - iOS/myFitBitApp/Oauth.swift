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
    
    fileprivate let permanentStorage = Storage.permanent
    
    init()
    {
    
    
    }

    
    
    //MARK: - Authorization Request
    
    /* returns true when data is retrieved from permant storage */
    func requestAuthorization(_ option:String)->Bool
    {
        if let dataSaved:NSDictionary = self.permanentStorage.retrievedDataFromDevice()
        {
            if let code:String = dataSaved .object(forKey: "code") as? String,
            let refreshToken:String = dataSaved .object(forKey: "refreshToken") as? String
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
    
    fileprivate func makeRequestThruSafari(_ url:String)
    {
        if let finalUrl:URL = URL(string: url)
        {
            print("\n \(finalUrl)")
            UIApplication.shared .openURL(finalUrl)
        }
    }//eom
    
    func handleAuthorizationResponce(_ responce:[AnyHashable: Any])->Bool
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
    func processCodeFromUrl(_ dirtyCode:String)->String?
    {
        if dirtyCode.contains("myfitbitapp://?code=") && dirtyCode.contains("#")
        {
            var cleanCode:String = dirtyCode.replacingOccurrences(of: "myfitbitapp://?code=", with: "")
            
            let lists:[String] = cleanCode.components(separatedBy: "#")
            
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
    fileprivate func createBasicAuthHeaderString(_ clientID:String, secretKey:String)->String
    {
        let headerString:String = "\(clientID):\(secretKey)"
        let headerData:Data   = headerString.data(using: String.Encoding.utf8)!
        let base64HeaderString  = headerData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

        return base64HeaderString
    }//eom

    
    //MARK: - Access Token Request
    func requestAccessToken(_ option:String, completion: @escaping ((_ accessTokenRetrieved: Bool?, _ error: NSError? ) -> Void))
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
        if let url:URL = URL(string: url)
        {
            print("\n \(url)")
            
            //request
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            
            //request type
            request.httpMethod = "POST"
            
            //request header
            let headerString  = createBasicAuthHeaderString(clientID, secretKey: secretKey)
            
            request.setValue("Basic \(headerString)", forHTTPHeaderField: "Authorization")
           
            //set body format
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            //adding body
            request.httpBody = createdAccessTokenRequestBody(redirect_uri, code: code, client_id: clientID)
           
            
            //request task
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
                { (data, response, error) in
                    
                    if error != nil
                    {
                        print("error \(error!.localizedDescription)")
                        completion(false, error as? NSError)
                    }
                    else
                    {
                        if let responseData = data
                        {
                            do{
                                let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                                
                                print("tokens: \(jsonResult)")
                                
                                //saving token data
                                if let resultsDict:NSDictionary = jsonResult as? NSDictionary
                                {
                                    //errors
                                    if let errorsDict = resultsDict .object(forKey: "errors")
                                    {
                                        print("\n\n errors: \(errorsDict)")
                                        self.permanentStorage.deleteDataFromDevice()
                                        completion(false, nil)
                                    }
                                    
                                    
                                    //access token & refresh token
                                    if let accessToken:String = resultsDict .object(forKey: "access_token") as? String, accessToken != "",
                                        let refreshToken:String = resultsDict .object(forKey: "refresh_token") as? String, refreshToken != ""
                                    {
                                        switch(option)
                                        {
                                            case "fitbit":
                                                
                                                //update model
                                                self.fitbit.accessToken = accessToken
                                                self.fitbit.refreshToken = refreshToken
                                                
                                                //save on device
                                                self.permanentStorage.saveDataOnDevice(self.fitbit.authCode, refreshToken: refreshToken)
                                                
                                                completion(true, nil)
                                                break
                                            default:
                                                completion(false,nil)
                                                break
                                        }//eo-switch
                                    }
                                    else
                                    {
                                        completion(false,nil)
                                    }
                                }
                                else
                                {
                                    print("un-able to get Dict")
                                    completion(false,nil)
                                }
                            }
                            catch
                            {
                                print("could not serialize data\n")
                                completion(false,nil)
                            }
                        }
                    }
                    
                    completion(false,error as NSError?)
            })
            task.resume()
        }
        else
        {
            let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
            completion(false, error)
        }
    }//eom
   
    
    //MARK:  Access Token Body Builder
    fileprivate func createdAccessTokenRequestBody(_ redirect_uri:String, code:String, client_id:String)->Data?
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
            guard let currValue:String = parameters .object(forKey: currKey) as? String else { continue }
            
            if addedFirstKey == false
            {
                let stringToAdd = "\(currKey)=\(currValue)"
                bodyString = bodyString .appending(stringToAdd) as NSString
                
                addedFirstKey = true
            }
            else
            {
                let stringToAdd = "&\(currKey)=\(currValue)"
                bodyString = bodyString .appending(stringToAdd) as NSString
                
            }
        }//eofl
        
        if let bodyStringData:Data = bodyString.data(using: String.Encoding.utf8.rawValue)
        {
            return bodyStringData
        }
        
        return nil
    }//eom

    
   
    
    
    //MARK:  Refresh Token Body Builder
    fileprivate func createdRefreshTokenRequestBody(_ refresh_token:String)->Data?
    {
        let parameters:NSMutableDictionary  = NSMutableDictionary()
        parameters["grant_type"]            = "refresh_token"
        parameters["refresh_token"]         = refresh_token
        
        var addedFirstKey:Bool = false
        var bodyString:NSString = ""
        let paramKeys = parameters.allKeys
        for currKey in paramKeys
        {
            guard let currValue:String = parameters .object(forKey: currKey) as? String else { continue }
            
            if addedFirstKey == false
            {
                let stringToAdd = "\(currKey)=\(currValue)"
                bodyString = bodyString .appending(stringToAdd) as NSString
                
                addedFirstKey = true
            }
            else
            {
                let stringToAdd = "&\(currKey)=\(currValue)"
                bodyString = bodyString .appending(stringToAdd) as NSString
                
            }
        }//eofl
        
        if let bodyStringData:Data = bodyString.data(using: String.Encoding.utf8.rawValue)
        {
            return bodyStringData
        }
        
        return nil
    }//eom
    
 //MARK: - Refresh Token Request
    func requestRefreshToken(_ option:String, completion: @escaping ((_ accessTokenRetrieved: Bool?, _ error: NSError? ) -> Void))
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
    if let url:URL = URL(string: url)
    {
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        //request type
        request.httpMethod = "POST"
        
        //request header
        let headerString  = createBasicAuthHeaderString(clientID, secretKey: secretKey)
        
        request.setValue("Basic \(headerString)", forHTTPHeaderField: "Authorization")
        
        //set body format
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //adding body
        request.httpBody = createdRefreshTokenRequestBody(refreshToken)
    
        //request task
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
        { (data, response, error) in
           
            if error != nil
            {
                print("error \(error?.localizedDescription)")
                completion(false,error as NSError?)
            }
            else
            {
                if let responseData = data
                {
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)

                        print("tokens: \(jsonResult)")

                            //saving token data
                            if let resultsDict:NSDictionary = jsonResult as? NSDictionary
                            {
                                //errors
                                if let errorsDict = resultsDict .object(forKey: "errors")
                                {
                                    print("\n\n errors: \(errorsDict)")
                                    self.permanentStorage.deleteDataFromDevice()
                                    completion(false,nil)
                                }
                                
                                
                                //access token & refresh token
                                if let accessToken:String = resultsDict .object(forKey: "access_token") as? String, accessToken != "",
                                    let refreshToken:String = resultsDict .object(forKey: "refresh_token") as? String, refreshToken != ""
                                {
                                    switch(option)
                                    {
                                        case "fitbit":
                                            //update model
                                            self.fitbit.accessToken = accessToken
                                            self.fitbit.refreshToken = refreshToken
                                            
                                            //save on device
                                            self.permanentStorage.saveDataOnDevice(self.fitbit.authCode, refreshToken: refreshToken)
                                            
                                            completion(true,nil)
                                            break
                                        default:
                                            completion(false, nil)
                                            break
                                    }
                                }
                                else
                                {
                                    completion(false,nil)
                                }
                            }
                            else
                            {
                                print("un-able to get Dict")
                                completion(false,nil)
                            }
                        }
                        catch
                        {
                            print("could not serialize data\n")
                            completion(false,nil)
                        }
                    
                }//eo-data
            }//eo-else
             completion( false,error as NSError?)
        })
        task.resume()
    }
    else
    {
        let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
        completion(false, error)
    }
}//eom

    
    
    
    
}//eoc






