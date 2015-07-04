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
    var toUser: User?

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    let messageRepository = MessageRepository.sharedInstance
    
    override func viewDidLoad()
    {
        navigationItem.title = "Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendMessage")
        
        if messageThread != nil {
            userTextField.enabled = false
            userTextField.text = messageThread?.user?.fullname
            
            subjectTextField.enabled = false
            subjectTextField.text = messageThread?.subject
        }
        
        if toUser !== nil {
            userTextField.enabled = false
            userTextField.text = toUser!.fullname
            
            subjectTextField.becomeFirstResponder()
        }
    }
    
    func sendMessage()
    {
        var message = Message()
        if userWantsToSendNewMessage() {
            message.subject = subjectTextField.text
            message.body = bodyTextView.text
            message.participants = toUser!
            messageRepository.save(message)
        } else if userWantsToReply() {
            message.threadId = messageThread!.id
            message.body = bodyTextView.text
            API.sharedInstance.replyMessage(message)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    /**
        The API is handling this differently so we need to check what to do.
    */
    private func userWantsToReply() -> Bool
    {
        return toUser == nil && messageThread != nil
    }
    
    /**
        The API is handling this differently so we need to check what to do.
    */
    private func userWantsToSendNewMessage() -> Bool
    {
        return toUser != nil && messageThread == nil
    }
}
