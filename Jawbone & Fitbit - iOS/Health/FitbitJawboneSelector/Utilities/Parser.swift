//
//  ParseJawbone.swift
//  Health
//
//  Created by Luis Castillo on 3/25/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class Parser
{
    
    enum ParsingError: Error {
//        case MissingJson
//        case JsonParsingError
        case jsonParsing
        case noData
        case missingData
    }
    
    //MARK: - Jawbone Step Parser
    class func jawbone_parseSteps (_ data: AnyObject?) throws -> [Step]
    {
        var moveArray =  [Step]()
        
        guard let list:NSDictionary = data as? NSDictionary else {
            throw ParsingError.jsonParsing
        }
        
        print("list: ", list)
        
        guard let dataList:NSDictionary = list .object(forKey: "data") as? NSDictionary else {
            throw ParsingError.missingData
        }
        
        guard let items = dataList["items"] as? [[String:AnyObject]] else
        {
            throw ParsingError.noData
        }
        
        print("total count: ",items.count)
        
        for item in items
        {
            if let date:Int = item["date"] as? Int,
                let steps:String = item["title"] as? String
            {
                let movement : Step = Step(theDate: date, theSteps: steps)
                moveArray.append(movement)
            }
        }//eofl
        
        return moveArray
    }//eom

    
    //MARK: - Fitbit Step Parser
    class func fitbit_parseSteps (_ data: AnyObject?) throws -> [Step]
    {
        var moveArray =  [Step]()
        
        guard let list:NSDictionary = data as? NSDictionary else {
            throw ParsingError.jsonParsing
        }
        
        print("list: ", list)
        
        guard let dataList:NSArray = list .object(forKey: "activities-steps") as? NSArray else {
            throw ParsingError.missingData
        }
        
        
        for item in dataList
        {
            if let currActivity:NSDictionary = item as? NSDictionary
            {
                if let date:String = currActivity["dateTime"] as? String,
                    let steps:String = currActivity["value"] as? String
                {
                    let movement : Step = Step(theDate: date, theSteps: steps)
                    moveArray.append(movement)
                }
            }
        }//eofl
        
        return moveArray
    }//eom

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     ** data = recieved JSON package from UP server containing, access_token, token_type, expires_in, refresh_token
     ** Void = No return type as the credentials are stored to the OAuthCredential singleton.
     
     */
//    class func JSONparser (data: NSData) throws -> Void
//    {
//        if let jsonData : NSData = data
//        {
//            
//            do {
//                let jsonResults : AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
//                
//                if let jsonDictionary : NSDictionary = jsonResults as? NSDictionary {
//                    if let accessToken : String = jsonDictionary.objectForKey("access_token") as? String where accessToken != "",
//                        let tokenType : String = jsonDictionary.objectForKey("token_type") as? String where tokenType != "",
//                        let expireDate : Int = jsonDictionary.objectForKey("expires_in") as? Int,
//                        let refreshToken : String = jsonDictionary.objectForKey("refresh_token") as? String where refreshToken != "" {
//                        // apply properties to singleton here.
//                        OAuthCredential.UPOAuthCredentials.accessToken = accessToken
//                        OAuthCredential.UPOAuthCredentials.expireyDate = expireDate
//                        OAuthCredential.UPOAuthCredentials.refreshToken = refreshToken
//                        OAuthCredential.UPOAuthCredentials.tokenType = tokenType
//                    }
//                }
//            } catch {
//                throw ParsingError.JsonParsingError
//            }
//        } else {
//            throw ParsingError.MissingJson
//        }
//    }
    
    /*
     ** data = recieved JSON package from UP server containing, access_token, token_type, expires_in, refresh_token
     ** Void = No return type as the credentials are stored to the OAuthCredential singleton.
     
     data: { items: [{"title" : "X steps"}, {details: {date: 20140229}  }   ]   }
     This method should proivde an array of Move objects each with their own step(String) and date(int)
     
     */
//    class func stepDataParser (data: NSData) throws -> [Step]
//    {
//        
//        var moveArray =  [Step]()
//        guard let jsonData : NSData = data else {
//            throw ParsingError.MissingJson
//        }
//        do {
//            let jsonResults = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//            // Data
//            if let jsonDictionary = jsonResults["data"] as? [NSObject:AnyObject] {
//                // Items
//                if let items = jsonDictionary["items"] as? [[String:AnyObject]] {
//                    for item in items
//                    {
//                        if let date:Int = item["date"] as? Int,
//                            let steps:String = item["title"] as? String
//                        {
//                            let movement : Step = Step(theDate: date, theSteps: steps)
//                            moveArray.append(movement)
//                        }
//                    }//eofl
//                }
//            }
//        } catch {
//            throw ParsingError.JsonParsingError
//        }
//        return moveArray
//    }
    
    /*
     ** data = recieved JSON package from UP server containing, access_token, token_type, expires_in, refresh_token
     ** Int = return type Int to place into the switch statement when the status is called.
     
     meta: { items: [{"status code" : 200}, ...   ]   }
     This method should proivde a status code for the JSON response parameter to help users discern why their code doesnt work when the
     response returns an invalid response.
     
     */
//    class func responseParser (data: NSData) throws -> Int {
//        
//        var statusCode : Int = 0
//        guard let jsonData : NSData = data else {
//            throw ParsingError.MissingJson
//        }
//        
//        do {
//            let jsonResults = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//            
//            if let jsonDictionary = jsonResults["meta"] as? [NSObject: AnyObject] {
//                statusCode = jsonDictionary["status code"] as! Int
//            }
//        } catch {
//            throw ParsingError.JsonParsingError
//        }
//        return statusCode
//    }
    
  
}//eoc
