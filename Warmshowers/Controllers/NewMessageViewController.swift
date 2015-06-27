//
//  NewMessageViewController.swift
//  Warmshowers
//
//  Created by admin on 20/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController
{
    var messageThread: MessageThread?
    var user: User?

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad()
    {
        navigationItem.title = "Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendMessage")
        
        if messageThread != nil {
            userTextField.enabled = false
            userTextField.text = messageThread?.user?.name
            
            subjectTextField.enabled = false
            subjectTextField.text = messageThread?.subject
        }
        
        if user !== nil {
            userTextField.enabled = false
            userTextField.text = user!.name
            
            subjectTextField.becomeFirstResponder()
        }
    }
    
    func sendMessage()
    {
        // TDODO: send message ...
    }
}
