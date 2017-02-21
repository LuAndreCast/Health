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
            
        urlString = urlString + "\(url.authorization)"
        urlString = urlString + "response_type=code"
        urlString = urlString + "&client_id=\(clientID)"
        urlString = urlString + "&redirect_uri=\(redirectURI)"
        urlString = urlString + "&scope=\(scope)"
        
        return urlString
    }//eom
    
    
    
    //MARK: - Get Fitbit Data
    func getUserDataFromFitbit(_ urlString:String, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void))
    {
        //url
        if let url:URL = URL(string: urlString)
        {
            //request
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            
            //request type
            request.httpMethod = "GET"
            
            //request header
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            //request task
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                completion(data, response, error as? NSError)
            })
            task.resume()
        }
        else
        {
            let error:NSError = NSError(domain: "missing url string", code: 190, userInfo: nil)
            completion(nil, nil, error)
        }
        
        
    }//eom
    
   
}//eoc



