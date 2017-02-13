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

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return steps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let index:Int = indexPath.row
        let currStepInfo:Step = steps[index]


        let cell:stepTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as? stepTableViewCell)!

        cell.setCellContent(currStepInfo)

        return cell
    }//eom
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
 

}//eoc
