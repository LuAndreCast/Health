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
    func getSafariAuth( completionHandler:(safariCalled: Bool, error: NSError?) -> Void )
    {
        let urlString:String = self.createAuthorizationCodeURL()
        if let finalUrl:NSURL = NSURL(string: urlString)
        {
            print(finalUrl)
            if UIApplication.sharedApplication().canOpenURL(finalUrl)
            {
                UIApplication .sharedApplication() .openURL(finalUrl)
                completionHandler(safariCalled: true, error: nil)
            }
            else
            {
                completionHandler(safariCalled: false, error: safariCallError)
            }
        }
        else
        {
            completionHandler(safariCalled: false, error: safariCallError)
        }
    }//eom
    
    
    //MARK: Url Code cleanup
    func Safari_urlCodeCleanUp(url:String, completionHandler:(codeRetrieved:Bool)->Void)
    {
        if url.containsString("health://?code=") && url.containsString("#success")
        {
            var cleanCode:String = url.stringByReplacingOccurrencesOfString("health://?code=", withString: "")

            cleanCode = cleanCode.stringByReplacingOccurrencesOfString("#success", withString: "")
            
            self.code = cleanCode
            
            completionHandler(codeRetrieved: true)
        }
        else
        {
            completionHandler(codeRetrieved: false)
        }
    }//eom
    
    /**
    Required to send NSURLRequest to WKWebView in VC via selector.  


    */
    func getNSURLRequest() -> NSURLRequest{
        let urlString =  self.createAuthorizationCodeURL()
        let url : NSURL = NSURL (string :urlString)!
        let urlRequest = NSURLRequest(URL: url)

        return urlRequest
    }
    
    func Webview_urlCodeCleanUp(url:String, completionHandler:(codeRetrieved:Bool)->Void)
    {
        if url.containsString("?code=")
        {
             let cleanedCode = url.stringByReplacingOccurrencesOfString("jawboneauth://redirect?code=", withString: "")
            
            self.code = cleanedCode
            
            completionHandler(codeRetrieved: true)
        }
        else
        {
            completionHandler(codeRetrieved: false)
        }
    }//eom
    
    //MARK: Helpers
    private func createAuthorizationCodeURL()->String
    {
        var urlString:String = String()

        urlString = urlString .stringByAppendingString("\(self.urlAuth)")
        urlString = urlString .stringByAppendingString("response_type=code")
        urlString = urlString .stringByAppendingString("&client_id=\(self.clientID)")
        urlString = urlString .stringByAppendingString("&redirect_uri=\(self.redirect_uri)")
        urlString = urlString .stringByAppendingString("&scope=\(self.scope)")

        return urlString
    }//eom
    
    
    //MARK: -   Auth Part 2
    func getAccessToken( body:NSMutableDictionary, completion:( taskCompleted:Bool, error:NSError? )-> Void  )
    {
        let url:NSURL = NSURL(string: self.urlToken)!
        
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)

        //type
        request.HTTPMethod = "POST"

        //headers
        let basicHeader = self.createBasicHeader()
        let headers = [
            "authorization": basicHeader,
            "content-type": "application/x-www-form-urlencoded"
        ]

        request.allHTTPHeaderFields = headers
        
        //body
        let bodyData:NSData?    = self.createTokenBodyRequest(body)
        request.HTTPBody        = bodyData
        
        //task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            { (data:NSData?, response:NSURLResponse?, error:NSError?)  in
                
                do
                {
                    let jsonResult:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let resultDict:NSDictionary = jsonResult as? NSDictionary
                    {
                        var valuesObtained:Int = 0
                        
                        if let access_token:String = resultDict.objectForKey("access_token") as? String
                        {
                            self.accessToken = access_token
                            valuesObtained += 1
                        }
                        
                       if let refresh_token:String = resultDict.objectForKey("refresh_token") as? String
                        {
                            self.refreshToken = refresh_token
                            valuesObtained += 1
                        }
                        
                       if let expires_in:Int = resultDict.objectForKey("expires_in") as? Int
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
                            completion(taskCompleted: true, error: nil)
                        }
                        else
                        {
                            completion(taskCompleted: false, error: missingOauthValuesError)
                        }
                    }
                    else
                    {
                        completion(taskCompleted: false, error: emptyDataError)
                     
                    }
                }
                catch
                {
                    completion(taskCompleted: false, error: cantParseJson)
                }
        })
        task.resume()
    }//eom
    
    
    //MARK: Helpers
    private func createBasicHeader()->String
    {
        let headerString:String = "\(self.clientID):\(self.secretKey)"
        let headerData:NSData   = headerString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64HeaderString  = headerData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        let header:String = "Basic \(base64HeaderString)"
        return header
    }//eom
    
    private func createTokenBodyRequest(parameters:NSMutableDictionary)->NSData?
    {
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
    
    //MARK: - User Data
    func getUserData(urlString:String , completion:( results:AnyObject?, error:NSError? )-> Void )
    {
        let url:NSURL = NSURL(string: urlString)!
    
        //request
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)

        //type
        request.HTTPMethod = "GET"

        //headers
        let bearerHeader:String = self.createBearerHeader()
        let headers = [
            "authorization": bearerHeader
        ]
        
        request.allHTTPHeaderFields = headers

        //task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
            { (data:NSData?, response:NSURLResponse?, error:NSError?)  in

                
                if error != nil
                {
                    print(error?.localizedDescription)
                    completion(results: nil, error: error)
                }
                else if data != nil
                {
                    do
                    {
                        let jsonResult:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        
                        completion(results: jsonResult, error: nil)
                    }
                    catch
                    {
                        completion(results: nil, error: cantParseJson)
                    }
                }
                else
                {
                    completion(results: nil, error: emptyDataError)
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
    private func storeUserCredentials(theToken: String, theDate: String, theRefreshToken : String) {
        
        // make a dictionary object to store the credentials 
       // {[{clientID: the selected API}, {access_token : token}, {expiryDate : theDate}, {refresh_token : token} ] }
        let clientID = self.clientID
        let jsonObject : NSDictionary =
                [
                    "clientID" : clientID, "access_token" : theToken, "expiration_date" : theDate, "refresh_token" : theRefreshToken
                ]
        do {
        let APIKeys = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.init(rawValue: 0))
            let isValid = NSJSONSerialization.isValidJSONObject(jsonObject)
            if (isValid) {
                NSUserDefaults.standardUserDefaults().setObject(APIKeys, forKey: clientID)
            // TODO: delete when completed.
              print ("the result of storing key to NSUserDefaults was: \(isValid)")
            }
            
        } catch {
            print(error)
        }
    }

    //MARK: Helpers
    private func createBearerHeader()->String
    {
        let header:String = "Bearer \(self.accessToken)"
        return header
    }//eom

    
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
        print("accessToken      \(accessToken)")
        print("refreshToken     \(refreshToken)")
        print("\n")
    }//eom
    
    
}//eoc