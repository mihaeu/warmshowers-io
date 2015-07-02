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

class AuthenticationViewController: UIViewController, UITextFieldDelegate
{
    private let api = API.sharedInstance
    private let userRepository = UserRepository()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(antimated: Bool)
    {
        usernameTextField?.text = APISecrets.Username
        usernameTextField.becomeFirstResponder()
        usernameTextField.restorationIdentifier = "username"
        usernameTextField.delegate = self

        passwordTextField?.text = APISecrets.Password
        passwordTextField.delegate = self
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

    //--------------------------------------------------------------------------
    // MARK: UITextFieldDelegate
    //--------------------------------------------------------------------------

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // clicked 'Next' on username, switch to password field
        if textField.restorationIdentifier == Storyboard.UsernameLabelId {
            passwordTextField.becomeFirstResponder()
            return true
        }

        // password submitted, try logging in
        textField.resignFirstResponder()
        attemptLogin()

        return true
    }
}
