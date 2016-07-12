//
//  Constants.swift
//  Health
//
//  Created by Luis Castillo on 3/14/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

//MARK: - STRUCTS / ENUMS
struct urls
{
    var authorization:String
    var token:String
    var user:String
    var steps:String
}


enum stepsTimeStart:Int
{
    case thirty     = 30
    case ninety     = 90
    case halfYear   = 180
    case year       = 365
}

enum api:Int
{
    case none       = 0
    case fitbit     = 1
    case jawbone    = 2
}

//MARK: -  Errors
let safariCallError:NSError             = NSError(domain: "un-able to call safari", code: 9001, userInfo: nil)
let urlStringError:NSError              = NSError(domain: "missing url string", code: 9002, userInfo: nil)
let emptyDataError:NSError              = NSError(domain: "empty data", code: 9003, userInfo: nil)
let cantParseJson:NSError               = NSError(domain: "un-able to parse JSON", code: 9004, userInfo: nil)
let missingOauthValuesError:NSError     = NSError(domain: "un-able to obtain all the necessary Oauth Tokens", code: 9005, userInfo: nil)
let noneOptionSelected:NSError          = NSError(domain: "no option selected", code: 9005, userInfo: nil)


