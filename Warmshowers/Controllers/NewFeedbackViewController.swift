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
    
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    private class Sections
    {
        static let Experience = 0
        static let Met = 1
        static let Date = 2
        static let Feedback = 3
    }
    
    private let ExperienceValues = ["Positive, Neutral", "Negative"]
    private let MetValues = ["Host", "Guest", "Met Traveling","Other"]
    
    private var experience = "Positive"
    private var met = "Other"
    private var feedback = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "createFeedback")
        
        datePicker.addTarget(self, action: "dateChanged", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.hidden = true
        dateLabel.text = Utils.shortDate(NSDate())
    }
    
    func createFeedback()
    {
        let feedback = Feedback(
            id: Int(arc4random_uniform(9999)),
            toUser: toUser!,
            body: feedbackTextView.text,
            date: datePicker.date,
            rating: experience,
            type: met
        )

        FeedbackRepository().save(feedback)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
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
