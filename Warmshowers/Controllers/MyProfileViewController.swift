//
//  MyProfileViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 21/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import Haneke

class MyProfileViewController: UIViewController
{
    @IBOutlet weak var userPictureImageView: UIImageView!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languagesSpokenLabel: UILabel!
    
    private let api = API.sharedInstance
    private let userRepository = UserRepository()
    
    override func viewDidLoad()
    {
        let user = api.loggedInUser!
        userLabel.text =  user.name
        languagesSpokenLabel.text = user.languagesspoken
        descriptionLabel.attributedText = Utils.htmlToAttributedText(user.comments)
        
        UserPictureCache.sharedInstance.pictureById(user.uid).onSuccess { image in
            self.userPictureImageView.image = image
        }.onFailure { error in
                self.userPictureImageView.image = UserPictureCache.defaultPicture
        }
    }
    
    @IBAction func logout(sender: AnyObject)
    {
        userRepository.update(api.loggedInUser!, key: "password", value: "")
        api.logout(api.loggedInUser!.name, password: api.loggedInUser!.password).onSuccess() { success in
            self.performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
        }
    }
}
