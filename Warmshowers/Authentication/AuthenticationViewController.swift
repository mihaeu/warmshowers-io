//
//  AuthenticationViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 07/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import XCGLogger

class AuthenticationViewController: UIViewController
{
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.resignFirstResponder()
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!

    let authentication = Authentication()
    
    @IBAction func attemptLogin()
    {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            println("Login attempt with username: \(usernameTextField.text) and password: \(passwordTextField.text)")
            if authentication.login(usernameTextField.text, password: passwordTextField.text) {
                println("Login success: \(usernameTextField.text)")
            } else {
                println("Login failure: \(usernameTextField.text)")
            }
        }
    }
    
}
