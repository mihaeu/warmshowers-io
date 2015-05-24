//
//  OtherProfileViewController.swift
//  Warmshowers
//
//  Created by admin on 09/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController
{
    var user: User?
    
    @IBOutlet weak var userPictureImageView: UIImageView!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profileDescriptionTextView: UITextView!

    override func viewDidLoad()
    {
        if user != nil {
            userLabel.text =  user!.name
            
            API.sharedInstance.getUser(user!.uid)
                .onSuccess() { completeUser in
                    self.user = completeUser
                    self.displayUserData()
                }
            
            let url = NSURL(string: user!.thumbnailURL)!
            userPictureImageView.hnk_setImageFromURL(url)
        }
    }
    
    private func displayUserData()
    {
        if user != nil {
            profileDescriptionTextView.text = user!.comments
        }
    }
}
