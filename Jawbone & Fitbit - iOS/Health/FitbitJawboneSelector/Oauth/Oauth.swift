//
//  Oauth.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class Oauth
{
    var clientID:String     = ""
    var secretKey:String    = ""
    var redirect_uri:String = ""
    var scope:String        = ""
    
    //
    var code:String = ""
    
    //
    var accessToken:String      = ""
    var refreshToken:String     = ""
    var codeExpiration:String   = ""
    
    //urls
    var urlToken:String = ""
    var urlAuth:String  = ""
    
    //MARK: -  Constructor
    init() {
  
    }//eom
    
    //MARK: -   Auth Part 1
    func getSafariAuth( _ completionHandler:(_ safariCalled: Bool, _ error: NSError?) -> Void )
    {
        let urlString:String = self.createAuthorizationCodeURL()
        if let finalUrl:URL = URL(string: urlString)
        {
            print(finalUrl)
            if UIApplication.shared.canOpenURL(finalUrl)
            {
                UIApplication.shared .openURL(finalUrl)
                completionHandler(true, nil)
            }
            else
            {
                completionHandler(false, safariCallError)
            }
        }
        else
        {
            completionHandler(false, safariCallError)
        }
    }//eom
    
    
    //MARK: Url Code cleanup
    func Safari_urlCodeCleanUp(_ url:String, completionHandler:(_ codeRetrieved:Bool)->Void)
    {
        if url.contains("health://?code=") && url.contains("#")
        {
            var cleanCode:String = url.replacingOccurrences(of: "health://?code=", with: "")

            cleanCode = cleanCode.replacingOccurrences(of: "#_=_", with: "")
            
            self.code = cleanCode
            
            completionHandler(true)
        }
        else
        {
            completionHandler(false)
        }
    }//eom
    
    /**
    Required to send NSURLRequest to WKWebView in VC via selector.  


    */
    func getNSURLRequest() -> URLRequest{
        let urlString =  self.createAuthorizationCodeURL()
        let url : URL = URL (string :urlString)!
        let urlRequest = URLRequest(url: url)

        return urlRequest
    }
    
    func Webview_urlCodeCleanUp(_ url:String, completionHandler:(_ codeRetrieved:Bool)->Void)
    {
        if url.contains("?code=")
        {
             let cleanedCode = url.replacingOccurrences(of: "jawboneauth://redirect?code=", with: "")
            
            self.code = cleanedCode
            
            completionHandler(true)
        }
        else
        {
            completionHandler(false)
        }
    }//eom
    
    //MARK: Helpers
    fileprivate func createAuthorizationCodeURL()->String
    {
        var urlString:String = String()

        urlString = urlString + "\(self.urlAuth)"
        urlString = urlString + "response_type=code"
        urlString = urlString + "&client_id=\(self.clientID)"
        urlString = urlString + "&redirect_uri=\(self.redirect_uri)"
        urlString = urlString + "&scope=\(self.scope)"

        return urlString
    }//eom
    
    
    //MARK: -   Auth Part 2
    func getAccessToken( _ body:NSMutableDictionary, completion:@escaping ( _ taskCompleted:Bool, _ error:NSError? )-> Void  )
    {
        let url:URL = URL(string: self.urlToken)!
        
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)

        //type
        request.httpMethod = "POST"

        //headers
        let basicHeader = self.createBasicHeader()
        let headers = [
            "authorization": basicHeader,
            "content-type": "application/x-www-form-urlencoded"
        ]

        request.allHTTPHeaderFields = headers
        
        //body
        let bodyData:Data?    = self.createTokenBodyRequest(body)
        request.httpBody      = bodyData
        
        //task
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
            { (data:Data?, reponse:URLResponse?, error:Error?) in
               do
                {
                    let jsonResult:Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let resultDict:NSDictionary = jsonResult as? NSDictionary
                    {
                        var valuesObtained:Int = 0
                        
                        if let access_token:String = resultDict.object(forKey: "access_token") as? String
                        {
                            self.accessToken = access_token
                            valuesObtained += 1
                        }
                        
                       if let refresh_token:String = resultDict.object(forKey: "refresh_token") as? String
                        {
                            self.refreshToken = refresh_token
                            valuesObtained += 1
                        }
                        
                       if let expires_in:Int = resultDict.object(forKey: "expires_in") as? Int
                        {
                            //315000000
                            // 3600
                            //YYYYMMDD
                            // convert the expires in value to an actual date... 
                           // let expiresString = DateFormatter.intToDateString(expires_in)
                            let expiresString = String(expires_in)
                            let expiryDate = DateFormatter.addTimeToDateString(expiresString)
                            
                            self.codeExpiration = expiryDate
                            valuesObtained += 1
                        }
                        
                        if  valuesObtained > 2
                        {
                            self.storeUserCredentials(self.accessToken, theDate: self.codeExpiration, theRefreshToken: self.refreshToken)
                            completion(true, nil)
                        }
                        else
                        {
                            completion(false, missingOauthValuesError)
                        }
                    }
                    else
                    {
                        completion(false, emptyDataError)
                     
                    }
                }
                catch
                {
                    completion(false, cantParseJson)
                }
        })
        task.resume()
    }//eom
    
    
    //MARK: Helpers
    fileprivate func createBasicHeader()->String
    {
        let headerString:String = "\(self.clientID):\(self.secretKey)"
        let headerData:Data   = headerString.data(using: String.Encoding.utf8)!
        let base64HeaderString  = headerData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let header:String = "Basic \(base64HeaderString)"
        return header
    }//eom
    
    fileprivate func createTokenBodyRequest(_ parameters:NSMutableDictionary)->Data?
    {
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
    
    //MARK: - User Data
    func getUserData(_ urlString:String , completion:@escaping ( _ results:AnyObject?, _ error:NSError? )-> Void )
    {
        let url:URL = URL(string: urlString)!
    
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)

        //type
        request.httpMethod = "GET"

        //headers
        let bearerHeader:String = self.createBearerHeader()
        let headers = [
            "authorization": bearerHeader
        ]
        
        request.allHTTPHeaderFields = headers
 
        //task
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                if error != nil
                {
                    print(error!.localizedDescription)
                    completion(nil, error as NSError?)
                }
                else if data != nil
                {
                    do
                    {
                        let jsonResult:Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        completion(jsonResult as AnyObject?, nil)
                    }
                    catch
                    {
                        completion(nil, cantParseJson)
                    }
                }
                else
                {
                    completion(nil, emptyDataError)
                }
        })
        task.resume()
    }//eom
    
    /**
     Param: theToken : String - the access token retrieved from API
     Param: theDate : String - the date retrieved from API
     PAram: theRefreshToken : String  the refresh token retrieved from API
     
     Method compiles access token, date, and refresh token into JSON dictionary and is stored under the 
     key of the clientID.  This (hopefully) allows the app to easily test to ensure we are seeking the right API 
     data when we start the system check method.
    */
    fileprivate func storeUserCredentials(_ theToken: String, theDate: String, theRefreshToken : String) {
        
        // make a dictionary object to store the credentials 
       // {[{clientID: the selected API}, {access_token : token}, {expiryDate : theDate}, {refresh_token : token} ] }
        let clientID = self.clientID
        let jsonObject : NSDictionary =
                [
                    "clientID" : clientID, "access_token" : theToken, "expiration_date" : theDate, "refresh_token" : theRefreshToken
                ]
        do {
        let APIKeys = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            let isValid = JSONSerialization.isValidJSONObject(jsonObject)
            if (isValid) {
                UserDefaults.standard.set(APIKeys, forKey: clientID)
            // TODO: delete when completed.
              print ("the result of storing key to NSUserDefaults was: \(isValid)")
            }
            
        } catch {
            print(error)
        }
    }

    //MARK: Helpers
    fileprivate func createBearerHeader()->String
    {
        let header:String = "Bearer \(self.accessToken)"
        return header
    }//eom

    
    func clearAuthData()
    {
        self.code = ""
        self.accessToken = ""
        self.refreshToken = ""
        self.codeExpiration = ""
    }
    
    //MARK: - Debug
    func debug()
    {
        print("\n")
        print("CLIENT_ID        \(clientID)")
        print("SECRET_KEY       \(secretKey)")
        print("REDIRECT_URI     \(redirect_uri)")
        print("scope            \(scope)")
        print("urlToken         \(urlToken)")
        print("urlAuth          \(urlAuth)")
        print("code             \(code)")
        print("code Expiration  \(codeExpiration)")
        //
        print("accessToken      \(accessToken)")
        print("refreshToken     \(refreshToken)")
        print("\n")
    }//eom
    
    
    
}//eoc
