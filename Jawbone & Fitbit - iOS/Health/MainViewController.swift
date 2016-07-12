//
//  MainViewController.swift
//  Health
//
//  Created by Luis Castillo on 3/21/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SelectorResponder
{
    //properties
    @IBOutlet weak var getStepsButton: UIButton!
    @IBOutlet weak var timeframeChooser: UISegmentedControl!
    
    //models
    // instanciates a Selector class.
    let selectorModel:Selector = Selector.instance
    // assumes we have no Acess  Token at startup.  This must be verified.
    var hasAccessToken : Bool = false
    var authorizationCode : String? 
    
    
    //MARK: -  View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //TODO: delet when completed/
        //print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation());
        
        //
        self.selectorModel.delegate = self
        self.selectorModel.startUpServices()
        
        let optionSelected = self.selectorModel.apiSelected
        
        print("otside \(optionSelected)")
        switch optionSelected
        {
        case .fitbit:
            self.timeframeChooser.selectedSegmentIndex = 1
            self.timeframeChooser.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            break
        case .jawbone:
            self.timeframeChooser.selectedSegmentIndex = 2
            self.timeframeChooser.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            break
        case .none:
            self.timeframeChooser.selectedSegmentIndex = 0
            self.timeframeChooser.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            break
        }
    }//eom

        
    
    //MARK: -  Actions
    @IBAction func getSteps(sender:AnyObject)
    {
        var stepsDesired:stepsTimeStart = stepsTimeStart.thirty
        
        switch (self.timeframeChooser.selectedSegmentIndex)
        {
            //365
            case 3:
                stepsDesired = stepsTimeStart.year
                break
            //180
            case 2:
                stepsDesired = stepsTimeStart.halfYear
                break
            //90
            case 1:
                stepsDesired = stepsTimeStart.ninety
                break
            //30
            case 0:
                stepsDesired = stepsTimeStart.thirty
                break
            default:
                break
        }
        
        self.selectorModel.getSteps(stepsDesired, completion:
            { (steps, error) -> Void in
            
            if steps != nil
            {
                self.showSteps(steps!)
            }
            else
            {
                print("error \(error?.localizedDescription)")
            }
        })

    }//eo-a
    
    
    func showSteps(steps:[Step])
    {
        if let vc:StepsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("stepTVC") as? StepsTableViewController
        {
            vc.steps = steps
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            print("unable to show steps")
        }
    }//eom
    
    // MARK: - Selector Responder
    /**
    Param: Bool - Does the App have a current accessToken in NSUserDefaults?
    */
    func initialCheckResponse(isReady: Bool)
    {
        
        // check NSUserDefaults for access token? 
        // is access token expired?
        
        if isReady == false
        {
            //get auth info
            print("need to get auth info!!")
            self.launchJawboneWebView()
        }
        else
        {
            self.getStepsButton.hidden = false
        }
    }//eom
    
    /**
    Param : Bool - Did the app recieve an authroizationCode back (Jawbone Only)?

    */
    func finalCheckResponse(isReady: Bool)
    {
        if isReady == false
        {
            print("un-able to retrieve auth code")
        }
        else
        {
            self.getStepsButton.hidden = false
        }
    }//eom
    
    /**
    Method to continue Jawbone OAuth Process.  
        1. Create an NSURLRequest to send to server. 
        2. Instantiate a ViewController with a WKWebView contained within.  
            This will return an Authorization code which we will return to
            self.finalCheckResponse.
    */
    
    func launchJawboneWebView()
    {
        
        // retrieve the NSURLRequest from
       let urlRequest =  self.selectorModel.jawboneModel.getNSURLRequest()

        // call webview view controller.
//        let webViewController : webviewAuthViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("webViewController") as! webviewAuthViewController
//            webViewController.urlRequest = urlRequest
        
        let webViewController = WebAuthVC (nibName: "WebAuthVC", bundle: nil)
        webViewController.urlRequest = urlRequest
        
        self.presentViewController(webViewController, animated: true, completion: nil)
    }
    
    //MARK: Temp
    @IBAction func apiSelectorValueChanged(sender: UISegmentedControl)
    {
        self.getStepsButton.hidden = true
        
        let tag = sender.selectedSegmentIndex
        var apiSelected = api(rawValue: 0)!
        
        if (tag == 1)
        {
            apiSelected = api(rawValue: 1)!
        } else if (tag == 2)
        {
            apiSelected = api(rawValue: 2)!
        }
        
        self.selectorModel.updateAPISelection( apiSelected )
        self.selectorModel.startUpServices()
    }//eo-a
    
}//eoc
