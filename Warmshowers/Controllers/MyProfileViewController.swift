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
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var languagesSpokenLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var userPictureImageView: UIImageView!
    
    var api = API.sharedInstance
    
    override func viewDidLoad()
    {
        let user = api.loggedInUser!
        userLabel.text =  user.name
        languagesSpokenLabel.text = user.languagesspoken
        descriptionLabel.text = user.comments
        
        let url = NSURL(string: user.thumbnailURL)!
        userPictureImageView.hnk_setImageFromURL(url)
    }
}
