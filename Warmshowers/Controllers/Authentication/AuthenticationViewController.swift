//
//  AuthenticationViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 07/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import XCGLogger
import SwiftyDrop

class AuthenticationViewController: UIViewController
{
    private let api = API.sharedInstance
    private let userRepository = UserRepository()
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.resignFirstResponder()
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(antimated: Bool)
    {
        usernameTextField?.text = APISecrets.Username
        passwordTextField?.text = APISecrets.Password
    }
    
    @IBAction func attemptLogin()
    {
        api
            .login(usernameTextField.text, password: passwordTextField.text)
            .onSuccess() { user in
                self.userRepository.save(user)
                self.performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
            }
            .onFailure() { error in
                Drop.down("Incorrect username or password. Please try again ...", state: .Error)
            }
    }
}
