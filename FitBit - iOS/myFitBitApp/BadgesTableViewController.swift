//
//  BadgesTableViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/7/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class BadgesTableViewController: UITableViewController
{
    
    //properties
    var badges:Achievements  = Achievements()
    

    //MARK: - View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Badges"
    }//eom
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }//eom

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return badges.list.count
    }//eom

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:badgesTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "badgeCell", for: indexPath) as? badgesTableViewCell)!
        
        let index:Int = indexPath.row
        if index < self.badges.list.count
        {
            if let currBadge:Achievement = badges.list[index] as? Achievement
            {
                //image
                cell.badgeImageview.image = currBadge.shareImage.image
                
                //backgroundColor
                cell.backView.backgroundColor = currBadge.backgroundColor.color
                
                //shortname
                cell.shortNameLabel.text = currBadge.shortname
                
                //desc
                cell.descriptionLabel.text = currBadge.description
                
                //mobile desc
                cell.mobileDescriptionLabel.text = currBadge.mobileDescription
                
                //dateTime
                cell.dateTimeLabel.text = currBadge.dateTime
                
                //category
                cell.categoryLabel.text = currBadge.category
            }//eo-curr badge
        }//eo-valid index
        
        return cell
    }//eom
    
    
    
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
   
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
