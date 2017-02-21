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
    
    override func viewDidAppear(_ animated: Bool)
    {
        if vcInitLoaded == false
        {
           self.initSetup()
        }
    }//eom
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
        self.loadingFitbitIndicator.stopAnimating()
        self.loadingFitbitIndicator.isHidden = true
        self.connectingFitbitMessageLabel.isHidden = true
    }//eom
    
    //MARK: - Notifications
    func handleUrlReceived(_ sender: Notification)
    {
        if let dataReceived:[AnyHashable: Any] = sender .userInfo
        {
            let codeRetrieved:Bool = oauth.handleAuthorizationResponce(dataReceived)
            if codeRetrieved
            {
                oauth.requestAccessToken("fitbit", completion:
                    { (accessTokenRetrieved, error) -> Void in
                        if accessTokenRetrieved == true
                        {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                self.performSegue(withIdentifier: "goToUserView", sender: nil)
                                
                            })
                        }
                })
            }

        }
    }//eom
    
    
    //MARK: - Init Setup
    
    func initSetup()
    {
        
        self.loadingFitbitIndicator.isHidden = false
        self.connectingFitbitMessageLabel.isHidden = false
        self.loadingFitbitIndicator.startAnimating()
        
        NotificationCenter.default .addObserver(self, selector: #selector(HomeViewController.handleUrlReceived(_:)), name: NSNotification.Name(rawValue: "handleUrlReceived"), object: nil)
        
        let codeWasSaved:Bool =  self.oauth.requestAuthorization("fitbit")
        if codeWasSaved
        {
            self.oauth.requestRefreshToken("fitbit", completion:
                { (accessTokenRetrieved, error) -> Void in
                    if accessTokenRetrieved == true
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.performSegue(withIdentifier: "goToUserView", sender: nil)
                            
                        })
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                           _ = self.oauth.requestAuthorization("fitbit")
                            
                        })
                    }
            })
        }
    }//eom
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToUserView"
        {
            self.vcInitLoaded = false
            //let vc = segue.destinationViewController
        }
        
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue)
    {
        print("back in home")
    }//eo-a
    


}
