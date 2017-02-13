//
//  DateFormatter.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation


class DateFormatter
{
    let currentDate = Date()
    var dateFormatter = Foundation.DateFormatter()
    
    /*
     ** Parameter intDate Int returned from UP API indicating the date the steps were recorded on.
     ** Return String object with the dateInt in an NSDate formatted variable.
     
     Method to convert an int value to an String object
     
     There must be a dateFormatter object initialized in the class called "dateFormatter" as well as a variable called "currentDate" of type NSDate.
     */
    class func intToDateString (_ intDate : Int) -> String {
        // convert int to String
        let dateString : String = String (intDate)
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let d = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        let stringDate = dateFormatter.string(from: d)
        return stringDate
    }
    
    /*
     ** parameter amountToRewind the length to rewind the date.
     ** return string.
     Method to calculate back XX days from today and return a string object to paste into the API call url
     
     There must be a dateFormatter object initialized in the class called "dateFormatter" as well as a variable called "currentDate" of type NSDate.
     */
    class func dateRewinder (_ amountToRewind: Int) -> String {
        let dateFormatter = Foundation.DateFormatter()
        let currentDate = Date()
        // calculate the date based on rewind...
        let calculatedDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: amountToRewind, to: currentDate, options: NSCalendar.Options.init(rawValue: 0))
        
        // convert NSDate to string
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateInStringFormatted = dateFormatter.string(from: calculatedDate!)
        
        return dateInStringFormatted
    }
    
    
    func isCodeExpired(_ expiration: String)->Bool
    {
        let dateFormatter = Foundation.DateFormatter()
        let currentDate = Date()
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        if let dateFromString = dateFormatter.date(from: expiration)
        {
            return currentDate.isGreaterThanDate(dateFromString)
        }
        
        return true
        
    }//eom
    
    /*
     ** parameter String returned from API Call with the time in seconds the access token is good.
     ** return string the date that this access token will expire.
     Method to calculate back XX days from today and return a string object to paste into the API call url
     
     There must be a dateFormatter object initialized in the class called "dateFormatter" as well as a variable called "currentDate" of type NSDate.
     */
    class func addTimeToDateString(_ theTimeAdded: String) -> String
    {
        let theSeconds : Int = Int(theTimeAdded)!
        let currentDate = Date()
        let calendar = Calendar.current
        let date = (calendar as NSCalendar).date(byAdding: .second, value: theSeconds, to: currentDate, options: [])
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        let dateInStringFormatted = dateFormatter.string(from: date!)
        
        return dateInStringFormatted
    }
    
}
