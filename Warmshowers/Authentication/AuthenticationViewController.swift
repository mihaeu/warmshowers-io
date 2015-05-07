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
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username == "" || password == "" {
            return
        }
        
        if authentication.login(username, password: password) {
            log.info("Login success: \(username)")
            
            performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
        } else {
            log.info("Login failure: \(password)")
            
            let alertController = UIAlertController(
                title: "Login Problem",
                message: "Incorrect username or password. Please try again ...",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(
                UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            )
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowStartSegue {
            // TODO: handover the logged in user
        }
    }
}
