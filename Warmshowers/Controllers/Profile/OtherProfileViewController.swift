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
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    var user: User?
    private var userData = [[String]]()
    private var userFeedback = [Feedback]()
    
    let realm = Realm()
    let userRepository = UserRepository.sharedInstance
    let feedbackRepository = FeedbackRepository.sharedInstance
    
    let isFavoriteImage = UIImage(named: "nav-star-full")
    let isNoFavoriteImage = UIImage(named: "nav-star-empty")

    private class Section {
        static let ProfileOverview = 0
        static let UserInformation = 1
        static let Feedback = 2

        static let Title = [
            "Profile Overview",
            "User Information",
            "Feedback"
        ]
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let buttons = [
            UIBarButtonItem(image: user!.isFavorite == true ? isFavoriteImage : isNoFavoriteImage, style: .Plain, target: self, action: "favorite:"),
            UIBarButtonItem(image: UIImage(named: "nav-feedback"), style: .Plain, target: self, action: "feedback"),
            UIBarButtonItem(image: UIImage(named: "nav-message"), style: .Plain, target: self, action: "message")
        ]
        navigationItem.setRightBarButtonItems(buttons, animated: true)

        userRepository.findById(user!.id).onSuccess { user in
            self.user = user
            self.setUpUserData()
            self.tableView.reloadData()
        }

        feedbackRepository.getAllByUser(user!).onSuccess() { userFeedback in
            self.userFeedback = userFeedback
            self.tableView.reloadData()
        }
    }

    private func setUpUserData()
    {
        if user?.spokenLanguages != "" {
            userData.append(["Languages", user!.spokenLanguages])
        }
        if user?.fullname != "" {
            userData.append(["Full Name", user!.fullname])
        }
        if user?.mobilePhone != "" {
            userData.append(["Mobile Phone", user!.mobilePhone])
        }
        if user?.street != "" {
            userData.append(["Street", user!.street])
        }
        if user?.city != "" {
            userData.append(["City/Town", user!.city])
        }
        if user?.zipCode != "" {
            userData.append(["Zip Code", user!.zipCode])
        }
        if user?.country != "" && Constants.CountryCodes[user!.country] != nil {
            userData.append(["Country", Constants.CountryCodes[user!.country]!])
        }
        if user?.longitude != 0 && user?.latitude != 0 {
            userData.append(["GPS", "\(user!.latitude),\(user!.longitude)"])
        }
    }

    @IBAction func back(sender: AnyObject)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func favorite(sender: UIBarButtonItem)
    {
        if user != nil {
            // switch favorite status
            userRepository.update(user!, key: "isFavorite", value: !user!.isFavorite)
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
        if indexPath.section == Section.ProfileOverview {
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ProfileOverviewCellIdentifier) as? ProfileOverviewCell
            if cell == nil {
                cell = ProfileOverviewCell()
            }
            cell!.update(user!)
            return cell!
        } else if indexPath.section == Section.Feedback {
            let feedback = userFeedback[indexPath.row]
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

        cell!.textLabel?.text = userData[indexPath.row][0]
        cell!.detailTextLabel!.text = userData[indexPath.row][1]

        return cell!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == Section.ProfileOverview {
            return 1
        } else if section == Section.UserInformation {
            return userData.count
        } else {
            return userFeedback.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == Section.ProfileOverview {
            return nil
        }
        return Section.Title[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return Section.Title.count
    }
}
