//
//  OtherProfileViewController.swift
//  Warmshowers
//
//  Created by admin on 09/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit
import Cartography
import RealmSwift

class OtherProfileViewController: UIViewController
{
    var user: User?
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var scrollContainerView: UIView!
    var userPictureImageView: UIImageView!
    var profileDescriptionLabel: UILabel!
    
    let realm = Realm()
  
    override func viewDidLoad()
    {
        if user != nil {
            userLabel.text =  user!.name
            
            API.sharedInstance.getUser(user!.uid)
                .onSuccess() { completeUser in
                    self.user = completeUser
                    self.displayUserData()
                }
            
            let containerSize = CGSize(width: 250.0, height: 640.0)
            scrollContainerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
            scrollView.addSubview(scrollContainerView)
            
            let url = NSURL(string: user!.thumbnailURL)!
            userPictureImageView = UIImageView()
            userPictureImageView.frame = CGRectMake(0, 0, 179, 200)
            userPictureImageView.hnk_setImageFromURL(url)
            scrollView.addSubview(userPictureImageView)
            
            scrollView.contentSize = containerSize;
            
            let newColor = user?.isFavorite == true ? UIColor.greenColor() : UIColor.redColor()
            favoriteButton.setTitleColor(newColor, forState: .Normal)
        }
    }
    
    private func displayUserData()
    {
        if user != nil {
            profileDescriptionLabel = UILabel()
            profileDescriptionLabel.attributedText = NSAttributedString(
                data: user!.comments.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil
            )

            profileDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            profileDescriptionLabel.numberOfLines = 0
            
            scrollView.addSubview(profileDescriptionLabel)
            
            layout(userPictureImageView, profileDescriptionLabel) { userPictureImageView, profileDescriptionLabel in
                userPictureImageView.top == userPictureImageView.superview!.top
                userPictureImageView.centerX == userPictureImageView.superview!.centerX
                userPictureImageView.width == 179
                userPictureImageView.height == 200
                
                profileDescriptionLabel.top == userPictureImageView.bottom + 8
                profileDescriptionLabel.centerX == userPictureImageView.centerX
                profileDescriptionLabel.width == 200
            }
            
            realm.write {
                self.realm.add(self.user!, update: true)
            }
        }
    }
    
    @IBAction func favorite(sender: UIButton)
    {
        if user != nil {
            let newColor = user?.isFavorite == true ? UIColor.redColor() : UIColor.greenColor()
            sender.setTitleColor(newColor, forState: .Normal)
            
            realm.write {
                self.user!.isFavorite = !self.user!.isFavorite
            }
        }
    }

}
