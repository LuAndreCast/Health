//
//  ActivitesViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/7/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class ActivitesViewController: UIViewController {

    //selection properties
    @IBOutlet var selectionLabels: [UILabel]!
    @IBOutlet var selectionSwitches: [UISwitch]!
    
    //date properties
    @IBOutlet var dateButtons: [UIButton]!
    
    //
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //table
    var tableController:ActivityTableViewController = ActivityTableViewController()
    
    //models - need to be adjusted
    let temp:FitBitAPI  = Oauth.Oauth2.fitbit
    
    
    
    //MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getActivityData()
        self.updateDateButtonColors()
        
        
        if let childs:NSArray = self.childViewControllers as NSArray?
        {
            if childs.count > 0
            {
                if let tableVC:ActivityTableViewController = childs.firstObject as? ActivityTableViewController
                {
                    tableController = tableVC
                }
            }
        }
        
        
        self.title = "Activities"
    }//eom

    
    //MARK: Activity Selectionw
    @IBAction func activitySelectionChanged(_ sender: UISwitch)
    {
        for currSwitch in selectionSwitches
        {
            if currSwitch == sender
            {
                continue
            }
            else
            {
                currSwitch .setOn(false, animated: true)
            }
        }//eofl
    }//eo-a
    
    
    
    //MARK: - Data Selection
    @IBAction func dateSelectionChanged(_ sender: UIButton)
    {
        for currButton in dateButtons
        {
            if currButton == sender
            {
                currButton.isSelected = true
                
                currButton.layer.borderWidth = 3.0
                currButton.layer.borderColor = UIColor.black.cgColor
                
            }
            else
            {
                currButton.isSelected = false
                
                currButton.layer.borderColor = UIColor.clear.cgColor
            }
        }//eofl
    }//eo-a
    
    func updateDateButtonColors()
    {
        //date buttons
        for currButton in dateButtons
        {
            currButton.layer.cornerRadius = 15
            
            if currButton.isSelected == true
            {
                currButton.layer.borderWidth = 3.0
                currButton.layer.borderColor = UIColor.black.cgColor
            }
        }
        
        //search button
        searchButton.layer.cornerRadius = 15
        searchButton.layer.borderWidth = 4.0
        searchButton.layer.borderColor = UIColor.lightGray.cgColor
    }//eom
    
    //MARK: 
    func getActivityData()
    {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        var activity:String = String()
        for currSwitch in selectionSwitches
        {
            if currSwitch.isOn == true
            {
                let switchTag = currSwitch.tag
                switch(switchTag)
                {
                    case 0:
                        activity = "calories"
                        break
                    case 1:
                        activity = "steps"
                        break
                    case 2:
                        activity = "distance"
                        break
                    case 3:
                        activity = "floors"
                        break
                    default :
                        break
                }
            }
        }//eofl
        
        
        
        var period:String = String()
        for currButton in dateButtons
        {
            if currButton.isSelected == true
            {
                let buttonTag = currButton.tag
                
                switch(buttonTag)
                {
                    case 0:
                        period = "1d"
                        break
                    case 1:
                        period = "7d"
                        break
                    case 2:
                        period = "30d"
                        break
                    case 3:
                        period = "max"
                        break
                    default :
                        break
                }
            }
        }//eofl
        
        
        var activityURLString:String = "\(temp.url.activities)"
        activityURLString = activityURLString + "\(activity)"
        activityURLString = activityURLString + "/date/today/\(period).json"
        
        //print(activityURLString)
        
        temp.getUserDataFromFitbit(activityURLString)
            { (data, response, error) -> Void in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    })
                }
                else if let responceData = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.processActivityData(jsonResult as AnyObject)
                    }
                    catch
                    {
                        
                    }
                }
        }//eo-
    }
    
    
    func processActivityData(_ results:AnyObject)
    {
        //print("results: \(results)")
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        })
        
        //print("results: \(results)")
        
        if let resultDict:NSDictionary = results as? NSDictionary
        {
            let activityKey:NSArray = resultDict.allKeys as NSArray
            if activityKey.count > 0
            {
                //activity key
                guard let activityType:String = activityKey[0] as? String else { return }
                if activityType == "errors"
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableController.activities = NSArray()
                        self.tableController.typeOfActivity = "NO DATA"
                        self.tableController.navBar.topItem?.title = "NO DATA"
                        self.tableController.tableView.reloadData()
                    })
                }
                else
                {
                    //activity list
                    if let activitiesList:NSArray = resultDict .object(forKey: activityType) as? NSArray
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableController.activities = activitiesList
                            self.tableController.typeOfActivity = activityType
                            self.tableController.navBar.topItem?.title = activityType
                            self.tableController.tableView.reloadData()
                        })
                    }

                }
            }
        }
    }//eo
    
    @IBAction func searchActivity(_ sender: AnyObject)
    {
        self.getActivityData()
    }//eo-a
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
