//
//  OtherProfileViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 09/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import RealmSwift

class OtherProfileViewController: UIViewController
{
    var user: User?
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var tableData = [[AnyObject]]()
    
    let realm = Realm()
    let userRepository = UserRepository.sharedInstance
    let feedbackRepository = FeedbackRepository.sharedInstance
    
    let isFavoriteImage = UIImage(named: "nav-star-full")
    let isNoFavoriteImage = UIImage(named: "nav-star-empty")
    
    let ProfileOverviewIndex = 0
    let UserInformationIndex = 1
    let FeedbackIndex = 2
    let headerTitles = [
        "Profile Overview",
        "User Information",
        "Feedback"
    ];

    override func viewDidLoad()
    {
        userRepository.findById(user!.id).onSuccess { user in
            self.user = user
            self.displayUserData()
        }

        super.viewDidLoad()
    }
    
    private func displayUserData()
    {
        let buttons = [
            UIBarButtonItem(image: user!.isFavorite ? isFavoriteImage : isNoFavoriteImage, style: .Plain, target: self, action: "favorite:"),
            UIBarButtonItem(image: UIImage(named: "nav-feedback"), style: .Plain, target: self, action: "feedback"),
            UIBarButtonItem(image: UIImage(named: "nav-message"), style: .Plain, target: self, action: "message")
        ]
        navigationItem.setRightBarButtonItems(buttons, animated: true)
        
        var userData = [String]()
        userData.append(user!.spokenLanguages)
        userData.append(user!.latitude.description)
        userData.append(user!.longitude.description)

        tableData = [[AnyObject]]()
        tableData.append([user!])
        tableData.append(userData)
        tableView.reloadData()
        
        feedbackRepository.getAllByUser(user!).onSuccess() { userFeedback in
            self.tableData.append(userFeedback)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func back(sender: AnyObject)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func favorite(sender: UIBarButtonItem)
    {
        if user != nil {
            realm.write {
                self.user!.isFavorite = !self.user!.isFavorite
            }
            sender.image = user?.isFavorite == true ? isFavoriteImage : isNoFavoriteImage
        }
    }
    
    func message()
    {
        performSegueWithIdentifier(Storyboard.ShowNewMessageSegue, sender: user)
    }
    
    func feedback()
    {
        performSegueWithIdentifier(Storyboard.ShowNewFeedbackSegue, sender: user)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowNewFeedbackSegue {
            if let newFeedbackViewController = segue.destinationViewController as? NewFeedbackViewController {
                newFeedbackViewController.toUser = user
            }
        } else if segue.identifier == Storyboard.ShowNewMessageSegue {
            if let newMessageViewController = segue.destinationViewController as? NewMessageViewController {
                newMessageViewController.toUser = user
            }
        }
        
    }
}

extension OtherProfileViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == ProfileOverviewIndex {
            let user = tableData[indexPath.section][indexPath.row] as! User
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ProfileOverviewCellIdentifier) as? ProfileOverviewCell
            if cell == nil {
                cell = ProfileOverviewCell()
            }
            cell!.update(user)
            return cell!
        } else if indexPath.section == FeedbackIndex {
            let feedback = tableData[indexPath.section][indexPath.row] as! Feedback
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FeedbackCellIdentifier) as? FeedbackCell
            if cell == nil {
                cell = FeedbackCell()
            }
            cell!.update(feedback)
            return cell!
        }

        var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.UserCellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: Storyboard.UserCellIdentifier)
        }

        cell!.textLabel?.text = "I'm a label"
        cell!.detailTextLabel!.text = "\(tableData[indexPath.section][indexPath.row])"

        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == ProfileOverviewIndex {
            return 1
        }
        return tableData[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == ProfileOverviewIndex {
            return nil
        }
        return headerTitles[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return tableData.count
    }
}
