//
//  StepsTableViewController.swift
//  Health
//
//  Created by Luis Castillo on 3/28/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class StepsTableViewController: UITableViewController
{

    var steps:[Step] = [Step]()

    //MARK: - View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }//eom

    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return steps.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let index:Int = indexPath.row
        let currStepInfo:Step = steps[index]


        let cell:stepTableViewCell = (tableView.dequeueReusableCellWithIdentifier("stepCell", forIndexPath: indexPath) as? stepTableViewCell)!

        cell.setCellContent(currStepInfo)

        return cell
    }//eom
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
 

}//eoc
