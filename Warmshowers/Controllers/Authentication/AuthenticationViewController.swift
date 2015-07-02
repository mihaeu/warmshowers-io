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
    @IBOutlet weak var loginButton: UIButton!

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
        disableLoginButton()
        api.login(usernameTextField.text, password: passwordTextField.text)
            .onSuccess() { user in
                self.userRepository.save(user)
                self.performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
            }.onFailure() { error in
                Drop.down("Incorrect username or password. Please try again ...", state: .Error)
            }.onComplete { result in
                self.enableLoginButton()
            }
    }

    /**
        Disables the login and shows a spinner.
    */
    private func disableLoginButton()
    {
        let label = loginButton.titleLabel
        loginButton.titleLabel?.removeFromSuperview()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.center = CGPointMake(loginButton.bounds.width / 2, loginButton.bounds.height / 2)
        loginButton.addSubview(spinner)
        spinner.startAnimating()
        loginButton.enabled = false
    }

    /**
        Enable the login and show the normal text.
    */
    private func enableLoginButton()
    {
        // button should only have one subview
        loginButton.subviews.first?.removeFromSuperview()
        var label = UILabel()
        label.text = "Login"
        label.center = CGPointMake(loginButton.bounds.width / 2, loginButton.bounds.height / 2)
        loginButton.addSubview(label)
        loginButton.enabled = true
    }

    //--------------------------------------------------------------------------
    // MARK: UITextFieldDelegate
    //--------------------------------------------------------------------------

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // password submitted, try logging in
        if textField.restorationIdentifier != Storyboard.UsernameLabelId {
            attemptLogin()
        }

        textField.resignFirstResponder()
        return true
    }
}
