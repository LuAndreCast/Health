//
//  Responders.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import Foundation

/*
    Used to send messages from AppDelegate(return from Safari) & ViewController(return from webview controller ) to Fitbit and Jawbone
*/
protocol codeResponder
{
    func receiveAuthCode(code:String)
}




/*
    Used to send messages from Selector (Fitbit and Jawbone) to ViewController
*/
protocol SelectorResponder
{
     func initialCheckResponse( isReady:Bool)
     func finalCheckResponse( isReady:Bool)
}

