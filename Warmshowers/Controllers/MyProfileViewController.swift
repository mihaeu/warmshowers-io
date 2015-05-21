//
//  MyProfileViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 21/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController
{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var api = API.sharedInstance
    
    override func viewDidLoad()
    {
        nameTextField.text = api.loggedInUser?.name
        commentsTextView.text = api.loggedInUser?.comments
    }
}
