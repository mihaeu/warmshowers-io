//
//  NewFeedbackViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 24/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import SwiftyDrop

class NewFeedbackViewController: UITableViewController
{
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!

    var toUser: User?
    private var experience = "Positive"
    private var met = "Other"
    private var feedback = ""

    private class Sections
    {
        static let Experience = 0
        static let Met = 1
        static let Date = 2
        static let Feedback = 3
    }
    
    private let ExperienceValues = ["Positive, Neutral", "Negative"]
    private let MetValues = ["Host", "Guest", "Met Traveling","Other"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Save,
            target: self,
            action: "createFeedback"
        )
        
        datePicker.addTarget(self, action: "dateChanged", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.hidden = true
        datePicker.maximumDate = NSDate()
        dateLabel.text = Utils.shortDate(NSDate())

        feedbackTextView.text = "Feedback for \(toUser!.fullname) ..."
    }

    /**
        Mocks the creation and saving of user feedback.
    */
    func createFeedback()
    {
        // id is generated like this, because the API access is still broken
        // conflicts are possible, but that is not an issue for now, another
        // test feedback will simply be overwritten
        let feedback = Feedback(
            id: Int(arc4random_uniform(9999)),
            toUser: toUser!,
            body: feedbackTextView.text,
            date: datePicker.date,
            rating: experience,
            type: met
        )

        if feedbackIsValid(feedback) {
            FeedbackRepository.sharedInstance.save(feedback)
            navigationController?.popToRootViewControllerAnimated(true)
        } else {
            Drop.down("Please make sure to use at least 10 words in your feedback.", state: .Error)
        }
    }

    /**
        Validate user feedback

        :param: feedback

        :returns: Bool
    */
    private func feedbackIsValid(feedback: Feedback) -> Bool
    {
        // minimum 10 words
        let words = feedback.body.componentsSeparatedByString(" ")
        if words.count < 10 {
            return false
        }

        return true
    }

    /**
        When the user changes the date on the date picker, update the date label.
    */
    func dateChanged()
    {
        dateLabel.text = Utils.shortDate(datePicker.date)
    }
}

extension NewFeedbackViewController: UITableViewDelegate
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == Sections.Experience {
            updateExperience(indexPath)
        } else if indexPath.section == Sections.Met {
            updateMet(indexPath)
        } else if indexPath.section == Sections.Date && indexPath.row == 0 {
            updateDate(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if datePicker.hidden && indexPath.section == Sections.Date && indexPath.row == 1 {
            return 0
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
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
    
    func updateDate(indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        datePicker.hidden = !datePicker.hidden
        if datePicker.hidden {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        dateLabel.text = Utils.shortDate(datePicker.date)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateExperience(indexPath: NSIndexPath)
    {
        uncheckAllCellsInSection(indexPath.section)
        checkCellForIndexPath(indexPath)
        experience = ExperienceValues[indexPath.row]
    }
    
    func updateMet(indexPath: NSIndexPath)
    {
        uncheckAllCellsInSection(indexPath.section)
        checkCellForIndexPath(indexPath)
        met = MetValues[indexPath.row]
    }
}
