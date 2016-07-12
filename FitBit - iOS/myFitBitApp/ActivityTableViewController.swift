//
//  ActivityTableViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/9/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    
    @IBOutlet weak var navBar: UINavigationBar!
    var activities:NSArray = NSArray()
    var typeOfActivity:String = String()
    
    //MARK: - View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.activities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:ActivityTableViewCell = (tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as? ActivityTableViewCell)!

        let index:Int = indexPath.row
        if index < self.activities.count
        {
            if let currActivity:NSDictionary = self.activities .objectAtIndex(index) as? NSDictionary
            {
                //date
                if let date:String = currActivity .objectForKey("dateTime") as? String
                {
                    cell.dateLabel.text = date
                }
                
                //value
                if let value:String = currActivity .objectForKey("value") as? String
                {
                    cell.valueLabel.text = value
                }
            }
        }
        
        return cell
    }//eom
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
 
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
