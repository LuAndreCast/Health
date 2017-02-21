//
//  ViewController.swift
//  myFitBitApp
//
//  Created by Luis Castillo on 2/29/16.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class UserViewController: UIViewController
{
    
    //Profile UI Properties
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    //device UI Properties
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceVersionLabel: UILabel!
    @IBOutlet weak var deviceLastSyncLabel: UILabel!
    
    //friends UI Properties
    @IBOutlet weak var friendsButton: UIButton!
    
    //badges UI Properties
    @IBOutlet weak var badgesButton: UIButton!
    
    //activites UI Properties
    
    @IBOutlet weak var activitiesButton: UIButton!
    
    //lifetime stats UI Properties
    @IBOutlet weak var lifetime_total_distanceLabel: UILabel!
    @IBOutlet weak var lifetime_total_floorsLabel: UILabel!
    @IBOutlet weak var lifetime_total_stepsLabel: UILabel!
    
    @IBOutlet weak var lifetime_best_distanceLabel: UILabel!
    @IBOutlet weak var lifetime_best_floorsLabel: UILabel!
    @IBOutlet weak var lifetime_best_stepsLabel: UILabel!
    @IBOutlet weak var lifetime_best_distanceDateLabel: UILabel!
    @IBOutlet weak var lifetime_best_floorsDateLabel: UILabel!
    @IBOutlet weak var lifetime_best_stepsDateLabel: UILabel!
    
    
    //properties
    var user:User                   = User()
    var device:Device               = Device()
    var friends:Friends             = Friends()
    var achievements:Achievements   = Achievements()
    var lifeTimeStats:LifeTimeStats = LifeTimeStats()
    
    //models - need to be adjusted
    let temp:FitBitAPI  = Oauth.Oauth2.fitbit
    
    
    
    //MARK: - View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.getUserProfileData()
        self.getDeviceData()
        self.getFriendsData()
        self.getBadgesData()
        self.getLifetimeStatsData()
    }//eom
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.topItem?.title = "Welcome \(self.user.name)!"
        self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height / 2
    }//eom
    
    
    //MARK: Profile
    func getUserProfileData()
    {
        temp.getUserDataFromFitbit(temp.url.profile)
            { (data, response, error) -> Void in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                }
                else if let responceData = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.processUserProfileData(jsonResult as AnyObject)
                    }
                    catch
                    {
                        
                    }
                }
        }//eo-
    }//eom
    
    func processUserProfileData(_ results:AnyObject)
    {
        //print("results: \(results)")
        
        
        user = User(profile: results)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            //name
            self.nameLabel.text = self.user.name
            self.navigationController?.navigationBar.topItem?.title = "Welcome \(self.user.name)!"
            
            //age
            self.ageLabel.text = "\(self.user.age)"
            
            //dob
            self.dobLabel.text = self.user.dob
            
            //gender
            self.genderLabel.text = self.user.gender
            
            //user Image
            self.userProfileImageView.image = self.user.profileImage.image
        })
       
    }//eom
    
    //MARK: Device
    func getDeviceData()
    {
        temp.getUserDataFromFitbit(temp.url.devices)
        { (data, response, error) -> Void in
            if error != nil
            {
                print("error: \(error?.localizedDescription)")
            }
            else if let responceData = data
            {
                do
                {
                    let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                    self.processDeviceData(jsonResult as AnyObject)
                }
                catch
                {
                    
                }
            }
        }//eo-
    }//eom
    
    func processDeviceData(_ results:AnyObject)
    {
        //print("device info: \(results)")
        
        self.device = Device(device: results)
        
        DispatchQueue.main.async(execute: { () -> Void in
             self.deviceVersionLabel.text = self.device.version
             self.deviceLastSyncLabel.text = self.device.lastSync
        })
    }//eom
    
    
    //MARK: Friends
    func getFriendsData()
    {
        temp.getUserDataFromFitbit(temp.url.friends)
            { (data, response, error) -> Void in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                }
                else if let responceData = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.processFriendsData(jsonResult as AnyObject)
                    }
                    catch
                    {
                        
                    }
                }
        }//eo-
    }//eom
    
    func processFriendsData(_ results:AnyObject)
    {
        //print("friends: \(results)")
        
        self.friends = Friends(friends: results)
        
        DispatchQueue.main.async(execute: { () -> Void in
                
            let count:Int = self.friends.list.count

            self.friendsButton.setTitle("\(count) Friends", for: UIControlState())    
        })

    }//eom
    
    //MARK: Badges
    func getBadgesData()
    {
        temp.getUserDataFromFitbit(temp.url.badges)
            { (data, response, error) -> Void in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                }
                else if let responceData = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.processBadgesData(jsonResult as AnyObject)
                    }
                    catch
                    {
                        
                    }
                }
        }//eo-
    }//eom
    
    func processBadgesData(_ results:AnyObject)
    {
        //print("badges: \(results)")
        
        self.achievements =  Achievements(badges: results)
        
        DispatchQueue.main.async(execute: { () -> Void in
        
            let count:Int = self.achievements.list.count
            
            self.badgesButton.setTitle("\(count) Badges", for: UIControlState())
        })
    }//eom
    
    
    //MARK: Lifetime Stats
    func getLifetimeStatsData()
    {
        temp.getUserDataFromFitbit(temp.url.lifetimestats)
            { (data, response, error) -> Void in
                if error != nil
                {
                    print("error: \(error?.localizedDescription)")
                }
                else if let responceData = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.processLifetimeStatsData(jsonResult as AnyObject)
                    }
                    catch
                    {
                        
                    }
                }
        }//eo-
    }//eom
    
    func processLifetimeStatsData(_ results:AnyObject)
    {
        self.lifeTimeStats = LifeTimeStats(results: results)
        
        DispatchQueue.main.async { () -> Void in
            //lifetime
            self.lifetime_total_distanceLabel.text      = self.lifeTimeStats.lifetimeDistance
            self.lifetime_total_floorsLabel.text        = self.lifeTimeStats.lifetimeFloors
             self.lifetime_total_stepsLabel.text        = self.lifeTimeStats.lifetimeSteps
            
            //best
            self.lifetime_best_distanceLabel.text       = self.lifeTimeStats.bestDistance.date
            self.lifetime_best_distanceDateLabel.text   = self.lifeTimeStats.bestDistance.value
            
            self.lifetime_best_floorsLabel.text         = self.lifeTimeStats.bestFloors.date
            self.lifetime_best_floorsDateLabel.text     = self.lifeTimeStats.bestFloors.value
            
            self.lifetime_best_stepsLabel.text          = self.lifeTimeStats.bestSteps.date
            self.lifetime_best_stepsDateLabel.text      = self.lifeTimeStats.bestSteps.value
        }
    }//eom
    
    
    
    //MARK: Navigarion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let segueID = segue.identifier
        let destinationVC = segue.destination
        
        
        if segueID == "goToFriends"
        {
            if let vc:FriendsTableViewController = destinationVC as? FriendsTableViewController
            {
                vc.userFriends = friends
            }
        
        }
        else if segueID == "goToBadges"
        {
            if let vc:BadgesTableViewController = destinationVC as? BadgesTableViewController
            {
              vc.badges = achievements
            }
        }
        else if segueID == "goToActivites"
        {
            
        }
    }//eom
    
    
    //MARK: -
    @IBAction func signOut(_ sender: AnyObject)
    {
        //FIX ME - temp
        Storage().deleteDataFromDevice()
        
        self.performSegue(withIdentifier: "goBackHome", sender: self)
        
    }//eom
    
   
    
    //MARK: - Memory
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//eom
    
    

}//eoc

