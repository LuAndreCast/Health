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
func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void))
{
    NSURLSession.sharedSession().dataTaskWithURL(url)
        { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
}



func getImageFromUrl(url:NSURL, completion: ((imageDownloaded: UIImage, error: NSError? ) -> Void))
{
    NSURLSession.sharedSession().dataTaskWithURL(url)
        { (data, response, error) in
            
            if error == nil
            {
                if let imageData:NSData = data
                {
                    if let image:UIImage = UIImage(data: imageData)
                    {
                        completion(imageDownloaded: image, error: nil)
                    }
                }
            }//eo-image
            
            //no image
            completion(imageDownloaded: UIImage(), error: error)
        }.resume()
}//eo-m


