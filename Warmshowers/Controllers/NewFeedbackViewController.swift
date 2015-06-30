//
//  NewFeedbackViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 24/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class NewFeedbackViewController: UIViewController
{
    var toUser: User?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "createFeedback")
    }
    
    func createFeedback()
    {
        let feedback = Feedback(
            id: Int(arc4random_uniform(9999)),
            toUser: toUser!,
            body: "This is a really long feedback message and we are very proud of our feedback writing skills and so forth and so forth.",
            year: 2015,
            month: 6,
            rating: "Positive",
            type: "Guest"
        )
        
        FeedbackRepository().save(feedback)
        API.sharedInstance.createFeedbackForUser(feedback).onSuccess() { success in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }.onFailure() { error in
            let alertController = UIAlertController(
                title: "Feedback Problem",
                message: "Couldn't create feedback.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(
                UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            )
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
