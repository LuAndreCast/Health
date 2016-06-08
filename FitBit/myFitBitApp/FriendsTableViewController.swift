//
//  FriendsTableViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 3/7/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController
{

    //properties
    var userFriends:Friends = Friends()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
    }//eom

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }//eom

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.userFriends.list.count
    }//eom
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:FriendsTableViewCell = (tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as? FriendsTableViewCell)!

        let index = indexPath.row
        if index < self.userFriends.list.count
        {
            if let currFriend:User = self.userFriends.list .objectAtIndex(index) as? User
            {
                //badge / achievements
                cell.setupAchievements(currFriend.achievements.list)
                
                //image
                cell.friendImageview.image = currFriend.profileImage.image
                
                //name
                cell.displayNameLabel.text = currFriend.name
                
                //age
                cell.ageLabel.text = "\(currFriend.age)"
                
                //member since
                cell.memberSinceLabel.text = currFriend.memberSince
            
            }//eo-curr friend
        }//eo-valid index
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

