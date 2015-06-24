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
        println(dateMetPicker.date.description)
        println(typeTextField.text)
        println(ratingTextField.text)
        println(feedbackTextField.text)
    }
}
