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
    private var user: User?
    
    override func viewDidLoad()
    {
        user = userRepository.findByActiveUser()
        userLabel.text =  user!.username
        languagesSpokenLabel.text = user!.spokenLanguages
        descriptionLabel.attributedText = Utils.htmlToAttributedText(user!.comments)
        
        UserPictureCache.sharedInstance.pictureById(user!.id).onSuccess { image in
            self.userPictureImageView.image = image
        }.onFailure { error in
                self.userPictureImageView.image = UserPictureCache.defaultPicture
        }
    }

    @IBAction func logout(sender: AnyObject)
    {
        userRepository.update(user!, key: "password", value: "")
        api.logout(user!).onSuccess() { success in
            self.performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
        }
    }

    // TODO: Implement ...
    func dataSource(user: User)
    {
        let sections = [
            "Account",
            "Location",
            "Member"
        ]
        
        var data = [String:[String:String]]()

        data["Account"] = ["Username": user.username]
        data["Location"] = [
            "Country": user.country,
            "Street": "",
            "Additional": "",
            "City": "",
            "State/Province": "",
            "Postal Code": ""
        ]
        data["Member"] = [
            "Full Name": "",
            "About you": "",
            "Home Phone": "",
            "Mobile Phone": "",
            "Work Phone": "",
            "Preferred Notice": "",
            "Max. Guests": "",
            "Closest Hotel": "",
            "Closest Campsite": "",
            "Closest Bike Shop": "",
            "Spoken Languages": "",
            "Website": ""
        ]
        data["Services"] = [
            "Bed": "",
            "Food": "",
            "Laundry": "",
            "Tent": "",
            "SAG": "",
            "Shower": "",
            "Storage": "",
            "Kitchen": ""
        ]
        data["Settings"] = [
            "N/A" : "",
            "Opt-Out" : "",
            "Time-Zone" : ""
        ]
    }
}
