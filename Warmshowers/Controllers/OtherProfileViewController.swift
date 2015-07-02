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
    var userId = 0
    var user = User() // !!!!!!!!!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!

    let isFavoriteImage = UIImage(named: "nav-star-full")
    let isNoFavoriteImage = UIImage(named: "nav-star-empty")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.dataSource = OtherProfileDataSource(userId: userId)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func displayUserData()
    {
        let buttons = [
            UIBarButtonItem(image: user.isFavorite ? isFavoriteImage : isNoFavoriteImage, style: .Plain, target: self, action: "favorite:"),
            UIBarButtonItem(image: UIImage(named: "nav-feedback"), style: .Plain, target: self, action: "feedback"),
            UIBarButtonItem(image: UIImage(named: "nav-message"), style: .Plain, target: self, action: "message")
        ]
        navigationItem.setRightBarButtonItems(buttons, animated: true)
    }
    
    @IBAction func back(sender: AnyObject)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func favorite(sender: UIBarButtonItem)
    {
//        if user != nil {
            // TODO: set favorite in dataSource
            sender.image = user.isFavorite == true ? isFavoriteImage : isNoFavoriteImage
//        }
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
