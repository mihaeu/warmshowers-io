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
        userLabel.text = api.loggedInUser?.name
        languagesSpokenLabel.text = api.loggedInUser?.languagesspoken
        descriptionLabel.text = api.loggedInUser?.comments
        
        let url = NSURL(string: "https://www.warmshowers.org/files/imagecache/profile_picture/pictures/picture-1.jpg")!
        userPictureImageView.hnk_setImageFromURL(url)
    }
}
