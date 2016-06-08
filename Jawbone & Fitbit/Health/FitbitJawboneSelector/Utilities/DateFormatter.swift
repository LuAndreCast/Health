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
    let currentDate = NSDate()
    var dateFormatter = NSDateFormatter()
    
    /*
     ** Parameter intDate Int returned from UP API indicating the date the steps were recorded on.
     ** Return String object with the dateInt in an NSDate formatted variable.
     
     Method to convert an int value to an String object
     
     There must be a dateFormatter object initialized in the class called "dateFormatter" as well as a variable called "currentDate" of type NSDate.
     */
    class func intToDateString (intDate : Int) -> String {
        // convert int to String
        let dateString : String = String (intDate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let d = dateFormatter.dateFromString(dateString)!
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        let stringDate = dateFormatter.stringFromDate(d)
        return stringDate
    }
    
    /*
     ** parameter amountToRewind the length to rewind the date.
     ** return string.
     Method to calculate back XX days from today and return a string object to paste into the API call url
     
     There must be a dateFormatter object initialized in the class called "dateFormatter" as well as a variable called "currentDate" of type NSDate.
     */
    class func dateRewinder (amountToRewind: Int) -> String {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        // calculate the date based on rewind...
        let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: amountToRewind, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        
        // convert NSDate to string
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateInStringFormatted = dateFormatter.stringFromDate(calculatedDate!)
        
        return dateInStringFormatted
    }
    
    
    func isCodeExpired(expiration: String)->Bool
    {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        if let dateFromString = dateFormatter.dateFromString(expiration)
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
    class func addTimeToDateString(theTimeAdded: String) -> String
    {
        let theSeconds : Int = Int(theTimeAdded)!
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Second, value: theSeconds, toDate: currentDate, options: [])
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        let dateInStringFormatted = dateFormatter.stringFromDate(date!)
        
        return dateInStringFormatted
    }
    
}
