//
//  HomeViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/4/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    //properties
    @IBOutlet weak var loadingFitbitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectingFitbitMessageLabel: UILabel!
    
    var vcInitLoaded:Bool = false
    
    let oauth:Oauth = Oauth.Oauth2
    
    //MARK: View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.vcInitLoaded = true
        self.initSetup()
        
    }//eom
    
    override func viewDidAppear(animated: Bool)
    {
        if vcInitLoaded == false
        {
           self.initSetup()
        }
    }//eom
    
    override func viewWillDisappear(animated: Bool)
    {
        
        self.loadingFitbitIndicator.stopAnimating()
        self.loadingFitbitIndicator.hidden = true
        self.connectingFitbitMessageLabel.hidden = true
    }//eom
    
    //MARK: - Notifications
    func handleUrlReceived(sender: NSNotification)
    {
        if let dataReceived:[NSObject: AnyObject] = sender .userInfo
        {
            let codeRetrieved:Bool = oauth.handleAuthorizationResponce(dataReceived)
            if codeRetrieved
            {
                oauth.requestAccessToken("fitbit", completion:
                    { (accessTokenRetrieved, error) -> Void in
                        if accessTokenRetrieved == true
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.performSegueWithIdentifier("goToUserView", sender: nil)
                                
                            })
                        }
                })
            }

        }
    }//eom
    
    
    //MARK: - Init Setup
    
    func initSetup()
    {
        
        self.loadingFitbitIndicator.hidden = false
        self.connectingFitbitMessageLabel.hidden = false
        self.loadingFitbitIndicator.startAnimating()
        
        NSNotificationCenter .defaultCenter() .addObserver(self, selector: Selector("handleUrlReceived:"), name: "handleUrlReceived", object: nil)
        
        let codeWasSaved:Bool =  self.oauth.requestAuthorization("fitbit")
        if codeWasSaved
        {
            self.oauth.requestRefreshToken("fitbit", completion:
                { (accessTokenRetrieved, error) -> Void in
                    if accessTokenRetrieved == true
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.performSegueWithIdentifier("goToUserView", sender: nil)
                            
                        })
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.oauth.requestAuthorization("fitbit")
                            
                        })
                    }
            })
        }
    }//eom
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "goToUserView"
        {
            self.vcInitLoaded = false
            //let vc = segue.destinationViewController
        }
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue)
    {
        print("back in home")
    }//eo-a
    


}
