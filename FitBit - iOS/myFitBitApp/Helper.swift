//
//  Helper.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/11/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation
import UIKit



struct dateAndValue
{
    var date:String
    var value:String
}


//MARK: - Image Download
func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void))
{
    URLSession.shared.dataTask(with: url, completionHandler:
        { (data:Data?, response:URLResponse?, error:Error?) in
        completion(data, response, error as? NSError)
    })
    .resume()
}



func getImageFromUrl(_ url:URL, completion: @escaping ((_ imageDownloaded: UIImage, _ error: NSError? ) -> Void))
{
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error == nil
            {
                if let imageData:Data = data
                {
                    if let image:UIImage = UIImage(data: imageData)
                    {
                        completion(image, nil)
                    }
                }
            }//eo-image
            
            //no image
            completion(UIImage(), error as NSError?)
        })        
.resume()
}//eo-m


