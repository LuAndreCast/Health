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
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ActivityTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityTableViewCell)!

        let index:Int = indexPath.row
        if index < self.activities.count
        {
            if let currActivity:NSDictionary = self.activities .object(at: index) as? NSDictionary
            {
                //date
                if let date:String = currActivity .object(forKey: "dateTime") as? String
                {
                    cell.dateLabel.text = date
                }
                
                //value
                if let value:String = currActivity .object(forKey: "value") as? String
                {
                    cell.valueLabel.text = value
                }
            }
        }
        
        return cell
    }//eom
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
