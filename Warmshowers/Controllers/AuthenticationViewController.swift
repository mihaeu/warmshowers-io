//
//  AuthenticationViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 07/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import XCGLogger
import RealmSwift

class AuthenticationViewController: UIViewController
{
    private var api = API.sharedInstance
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.resignFirstResponder()
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(antimated: Bool)
    {
        let result = Realm().objects(User).filter("password != ''")
        println(result.count)
        if result.count == 1 {
            let user = result.first!
            api.login(user.name, password: user.password).onSuccess { user in
                self.performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
            }
        }
        
        usernameTextField?.text = APISecrets.Username
        passwordTextField?.text = APISecrets.Password
    }
    
    @IBAction func attemptLogin()
    {
        api
            .login(usernameTextField.text, password: passwordTextField.text)
            .onSuccess() { user in
                Realm().write {
                    Realm().add(user, update: true)
                }
                self.performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
            }
            .onFailure() { error in
                let alertController = UIAlertController(
                    title: "Login Problem",
                    message: "Incorrect username or password. Please try again ...",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alertController.addAction(
                    UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
                )

                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }
}
