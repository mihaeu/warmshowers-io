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
    var user: User?
    
    @IBOutlet weak var dateMetPicker: UIDatePicker!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var feedbackTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "createFeedback")
    }
    
    func createFeedback()
    {
        let date = dateMetPicker.date
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear , fromDate: date)
        let year = components.year
        let month = components.month
        
        let type = typeTextField.text
        let rating = typeTextField.text
        let body = feedbackTextField.text
        
        let feedback = Feedback(
            userIdForFeedback: user!.uid,
//            userForFeedback: user!.name,
            userForFeedback: "rfay-testuser",
            body: body,
            year: year,
            month: month,
            rating: rating,
            type: type
        )
        
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
