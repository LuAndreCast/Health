//
//  Fitbit.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/10/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

class FitBitAPI:Fitbit
{
    static let model = FitBitAPI()

    //MARK: - Get Fitbit Data
    func getAuthString ()  -> String
    {
        var urlString:String = String()
            
        urlString = urlString .stringByAppendingString("\(url.authorization)")
        urlString = urlString .stringByAppendingString("response_type=code")
        urlString = urlString .stringByAppendingString("&client_id=\(clientID)")
        urlString = urlString .stringByAppendingString("&redirect_uri=\(redirectURI)")
        urlString = urlString .stringByAppendingString("&scope=\(scope)")
        
        return urlString
    }//eom
    
    
    
    //MARK: - Get Fitbit Data
    func getUserDataFromFitbit(urlString:String, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void))
    {
        //url
        if let url:NSURL = NSURL(string: urlString)
        {
            //request
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            //request type
            request.HTTPMethod = "GET"
            
            //request header
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            //request task
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
                { (data, response, error) in
                    completion(data: data, response: response, error: error)
            })
            task.resume()
        }
        else
        {
            let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
            completion(data: nil, response: nil, error: error)
        }
        
        
    }//eom
    
   
}//eoc



