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
    let userRepository = UserRepository()
    
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
        if user != nil {
            // if the user is not cached, get it from the API
            if user?.comments == nil || user?.comments == "" {
                API.sharedInstance.getUser(user!.uid)
                    .onSuccess() { completeUser in
                        self.user = completeUser
                        
                        let results = self.realm.objects(User).filter("uid = \(completeUser.uid)")
                        if results.count == 1 {
                            let userFromDb = results.first!
                            self.user?.isFavorite = userFromDb.isFavorite
                        }
                        self.realm.write {
                            self.realm.add(self.user!, update: true)
                        }
                        
                        self.displayUserData()
                }
            } else {
                displayUserData()
            }
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
        userData.append(user!.languagesspoken)
        userData.append(user!.latitude.description)
        userData.append(user!.longitude.description)
        
        tableData = [[AnyObject]]()
        tableData.append([user!])
        tableData.append(userData)
        tableView.reloadData()
        
        API.sharedInstance.getFeedbackForUser(user!.uid).onSuccess() { userFeedback in
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
                newFeedbackViewController.user = user
            }
        } else if segue.identifier == Storyboard.ShowNewMessageSegue {
            if let newMessageViewController = segue.destinationViewController as? NewMessageViewController {
                newMessageViewController.user = user
            }
        }
        
    }
}

extension OtherProfileViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == ProfileOverviewIndex {
            // TODO: special format with 2 columns except for the first column plzzz
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ProfileOverviewCellIdentifier) as? ProfileOverviewCell
            if cell == nil {
                cell = ProfileOverviewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.ProfileOverviewCellIdentifier)
            }
            
            let user = tableData[indexPath.section][indexPath.row] as! User
            cell!.fullnameLabel.text = user.fullname
            cell!.descriptionLabel.text = user.comments
            cell?.userPictureImageView.hnk_setImageFromURL(User.mobileURLFromId(user.uid), placeholder: Storyboard.DefaultUserPicture)
            cell?.userPictureImageView.layer.cornerRadius = 8
            cell?.userPictureImageView.clipsToBounds = true
            cell?.userPictureImageView.layer.borderWidth = 1.0;
            
            return cell!
        }
        
        if indexPath.section == FeedbackIndex {
            // TODO: refactor into init()s which set their property, thanks!
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FeedbackCellIdentifier) as? FeedbackCell
            if cell == nil {
                cell = FeedbackCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.FeedbackCellIdentifier)
            }
            
            let feedback = tableData[indexPath.section][indexPath.row] as! Feedback
            cell?.userLabel.text = "\(feedback.fromFullName)"
            cell?.feedbackLabel.attributedText = Utils.htmlToAttributedText(feedback.body)
            cell?.createdOnLabel.text = "\(feedback.rating) feedback written in \(Constants.Months[feedback.month]!) \(feedback.year)"
            
            cell?.userPictureImageView.hnk_setImageFromURL(User.thumbnailURLFromId(feedback.fromUserId), placeholder: Storyboard.DefaultUserThumbnail)
            cell?.userPictureImageView.layer.cornerRadius = 8
            cell?.userPictureImageView.clipsToBounds = true
            cell?.userPictureImageView.layer.borderWidth = 1.0;

            return cell!
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.UserCellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.UserCellIdentifier)
        }
        
        cell!.textLabel?.text = tableData[indexPath.section][indexPath.row] as? String
        cell!.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell!.textLabel?.numberOfLines = 0
        
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
