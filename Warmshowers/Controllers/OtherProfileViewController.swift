//
//  OtherProfileViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 09/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import Cartography
import RealmSwift

class OtherProfileViewController: UIViewController
{
    var user: User?
    
    var scrollContainerView: UIView!
    var profileDescriptionLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
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
    
    let UserInformationIndex = 0
    let FeedbackIndex = 1
    let headerTitles = [
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
        favoriteButton.style = user!.isFavorite == true
            ? UIBarButtonItemStyle.Done
            : UIBarButtonItemStyle.Plain
        
        self.title = user!.fullname
        
        var userData = [String]()
        userData.append(user!.fullname)
        userData.append(user!.comments)
        userData.append(user!.languagesspoken)
        userData.append(user!.latitude.description)
        userData.append(user!.longitude.description)
        
        tableData = [[AnyObject]]()
        tableData.append(userData)
        
        API.sharedInstance.getFeedbackForUser(user!.uid).onSuccess() { userFeedback in
            self.tableData.append(userFeedback)
            self.tableView.reloadData()
        }
        
//        let containerSize = CGSize(width: 250.0, height: 250.0)
//        scrollContainerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
//        scrollView.addSubview(scrollContainerView)
//        
//        let url = NSURL(string: user!.mobilePictureURL)!
//        userPictureImageView = UIImageView()
//        userPictureImageView.frame = CGRectMake(0, 0, 179, 200)
//        userPictureImageView.contentMode = .ScaleAspectFit
//        userPictureImageView.hnk_setImageFromURL(url)
//        scrollView.addSubview(userPictureImageView)
//        
//        scrollView.contentSize = containerSize;
//        
//        let newColor = user?.isFavorite == true ? UIColor.greenColor() : UIColor.redColor()
//        favoriteButton.setTitleColor(newColor, forState: .Normal)
//        
//        profileDescriptionLabel = UILabel()
//        profileDescriptionLabel.attributedText = NSAttributedString(
//            data: user!.comments.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
//            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil,
//            error: nil
//        )
//
//        profileDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        profileDescriptionLabel.numberOfLines = 0
//        
//        scrollView.addSubview(profileDescriptionLabel)
//        
//        layout(userPictureImageView, profileDescriptionLabel) { userPictureImageView, profileDescriptionLabel in
//            userPictureImageView.top == userPictureImageView.superview!.top
//            userPictureImageView.centerX == userPictureImageView.superview!.centerX
//            userPictureImageView.width == 179
//            userPictureImageView.height == 200
//            
//            profileDescriptionLabel.top == userPictureImageView.bottom + 8
//            profileDescriptionLabel.centerX == userPictureImageView.centerX
//            profileDescriptionLabel.width == 200
//        }
        
        tableView.reloadData()
    }
    
    @IBAction func back(sender: AnyObject)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addToFavorites(sender: UIBarButtonItem)
    {
        if user != nil {
            realm.write {
                self.user!.isFavorite = !self.user!.isFavorite
            }
            sender.style = user?.isFavorite == true
                ? UIBarButtonItemStyle.Done
                : UIBarButtonItemStyle.Plain
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowNewFeedbackSegue {
            if let newFeedbackViewController = segue.destinationViewController as? NewFeedbackViewController {
                newFeedbackViewController.user = user
            }
        }
    }
}

extension OtherProfileViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == UserInformationIndex {
            // TODO: special format with 2 columns except for the first column plzzz
            var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.UserCellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.UserCellIdentifier)
            }
            
            cell!.textLabel?.text = tableData[indexPath.section][indexPath.row] as? String
            cell!.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell!.textLabel?.numberOfLines = 0
            
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
            cell?.userPictureImageView.hnk_setImageFromURL(User.thumbnailURLFromId(feedback.fromUserId))
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
        return tableData[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headerTitles[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return tableData.count
    }
}
