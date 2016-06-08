//
//  TestWebViewController.swift
//  Health
//
//  Created by Randy McLain on 3/23/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit
import WebKit

class TestWebViewController: UIViewController, WKNavigationDelegate{
    
    
    //var myWebView : WKWebView?
    weak var navigationDelegate: WKNavigationDelegate?
    let preferences = WKPreferences()
    let configuration = WKWebViewConfiguration()
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    // attempt to pass variable to parentVC
    var delegate:codeResponder?
    
    //Incoming
    var urlRequest:NSURLRequest?
    var codeToSave:String = ""
    
    
    override func viewDidLoad() {
        
        
        
        
    }
    
    
}
