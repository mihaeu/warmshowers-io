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
    var userPictureImageView: UIImageView!
    var profileDescriptionLabel: UILabel!
    
    let realm = Realm()
  
    override func viewDidLoad()
    {
        if user != nil {
            // if the user is not cached, get it from the API
            if user?.comments == nil || user?.comments == "" {
                API.sharedInstance.getUser(user!.uid)
                    .onSuccess() { completeUser in
                        self.user = completeUser
//                        self.displayUserData()
                        
                        self.realm.write {
                            self.realm.add(self.user!, update: true)
                        }
                }
            } else {
//                displayUserData()
            }
        }
        
        super.viewDidLoad()
    }
    
//    private func displayUserData()
//    {
//        let containerSize = CGSize(width: 250.0, height: 250.0)
//        scrollContainerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
//        scrollView.addSubview(scrollContainerView)
//        
//        let url = NSURL(string: user!.thumbnailURL)!
//        userPictureImageView = UIImageView()
//        userPictureImageView.frame = CGRectMake(0, 0, 179, 200)
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
//    }
    
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
}
