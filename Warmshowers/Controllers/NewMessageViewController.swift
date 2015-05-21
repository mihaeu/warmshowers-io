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

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Message"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendMessage")
        
        if messageThread != nil {
            userTextField.enabled = false
            userTextField.text = messageThread?.user?.name
            
            subjectTextField.enabled = false
            subjectTextField.text = messageThread?.subject
        }
    }
    
    func sendMessage()
    {
        println(subjectTextField.text)
        println(bodyTextView.text)
    }
}
