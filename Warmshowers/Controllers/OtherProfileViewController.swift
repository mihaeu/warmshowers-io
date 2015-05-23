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
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var languagesSpokenLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    override func viewDidLoad()
    {
        if user != nil {
            userLabel.text =  user!.name
            languagesSpokenLabel.text = user!.languagesspoken
            descriptionLabel.text = user!.comments
            
            let url = NSURL(string: user!.thumbnailURL)!
            userPictureImageView.hnk_setImageFromURL(url)
        }
    }
}
