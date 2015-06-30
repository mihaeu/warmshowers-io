//
//  NewFeedbackViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 24/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class NewFeedbackViewController: UITableViewController
{
    var toUser: User?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private class Sections
    {
        static let Experience = 0
        static let Met = 1
        static let Date = 2
        static let Feedback = 3
    }
    
    private var experience = "Positive"
    private var met = "Other"
    private var date = NSDate()
    private var feedback = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "createFeedback")
        
//        datePicker.hidden = true
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

extension NewFeedbackViewController: UITableViewDelegate
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == Sections.Experience || indexPath.section == Sections.Met {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            uncheckAllCellsInSection(indexPath.section)
            checkCellForIndexPath(indexPath)
        }
    }

    func uncheckAllCellsInSection(sectionId: Int)
    {
        let numberOfRowsInSection = tableView.numberOfRowsInSection(sectionId)
        for var index = 0; index < numberOfRowsInSection; ++index {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: sectionId))?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func checkCellForIndexPath(indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
}
