//
//  MyProfileViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 21/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import Haneke
import SwiftyDrop
import IJReachability

class MyProfileViewController: UITableViewController
{
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var spokenLanguagesTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!

    private var user: User?

    private let api = API.sharedInstance
    private let userRepository = UserRepository.sharedInstance
    
    override func viewDidLoad()
    {
        let buttons = [
            UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save"),
            UIBarButtonItem(image: UIImage(named: "nav-logout"), style: .Plain, target: self, action: "logout")
        ]
        navigationItem.setRightBarButtonItems(buttons, animated: true)

        user = userRepository.findByActiveUser()
        if user != nil {
            descriptionTextView.text = user!.comments
            fullnameTextField.text = user!.fullname
            spokenLanguagesTextField.text = user!.spokenLanguages
            mobilePhoneTextField.text = user!.mobilePhone
            streetTextField.text = user!.street
            cityTextField.text = user!.city
            countryTextField.text = Constants.CountryCodes[user!.country]
            zipCodeTextField.text = user!.zipCode

            UserPictureCache.sharedInstance.pictureById(user!.id).onSuccess { image in
                self.userPictureImageView.image = image
            }.onFailure { error in
                self.userPictureImageView.image = UserPictureCache.defaultPicture
            }
        }
    }

    func save()
    {
        if user != nil {
            userRepository.update(user!, key: "comments", value: descriptionTextView.text)
            userRepository.update(user!, key: "fullname", value: fullnameTextField.text)
            userRepository.update(user!, key: "spokenLanguages", value: spokenLanguagesTextField.text)
            userRepository.update(user!, key: "mobilePhone", value: mobilePhoneTextField.text)
            userRepository.update(user!, key: "street", value: streetTextField.text)
            userRepository.update(user!, key: "city", value: cityTextField.text)
            userRepository.update(user!, key: "country", value: countryTextField.text)
            userRepository.update(user!, key: "zipCode", value: zipCodeTextField.text)
            
            userRepository.save(user!)
            Drop.down("All changes saved ...", state: .Success)

            view.endEditing(true)
        }
    }

    func logout()
    {
        if IJReachability.isConnectedToNetwork() {
            userRepository.update(user!, key: "password", value: "")
            api.logout(user!).onSuccess() { success in
                self.performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
            }
        } else {
            Drop.down("No internet connection, please try again later ...", state: .Info)
        }
    }
}
