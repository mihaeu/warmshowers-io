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
import IJReachability

class AuthenticationViewController: UIViewController, UITextFieldDelegate
{
    private let api = API.sharedInstance
    private let userRepository = UserRepository.sharedInstance
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!


    override func viewDidAppear(antimated: Bool)
    {
        usernameTextField?.text = APISecrets.Username
        usernameTextField.delegate = self

        passwordTextField?.text = APISecrets.Password
        passwordTextField.delegate = self
    }
    
    @IBAction func attemptLogin()
    {
        if !IJReachability.isConnectedToNetwork() {
            Drop.down("No internet connection, please try again later ...", state: .Info)
            return
        }

        disableLoginButton()
        api.login(usernameTextField.text, password: passwordTextField.text)
            .onSuccess() { user in
                self.userRepository.save(user)
                self.performSegueWithIdentifier(Storyboard.ShowStartSegue, sender: nil)
                self.enableLoginButton()
            }.onFailure() { error in
                Drop.down("Incorrect username or password. Please try again ...", state: .Error)
                self.enableLoginButton()
            }
    }

    /**
        Disables the login and shows a spinner.
    */
    private func disableLoginButton()
    {
        loginButton.enabled = false
        loginButton.hidden = true

        spinner.startAnimating()
    }

    /**
        Enable the login and show the normal text.
    */
    private func enableLoginButton()
    {
        spinner.stopAnimating()

        loginButton.enabled = true
        loginButton.hidden = false
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

        view.endEditing(true)
        return true
    }
}
