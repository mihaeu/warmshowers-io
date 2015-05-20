//
//  MessagesViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource
{
    var api = API()
    var messages = [Message]()
    
    let messageCellIdentifier = "messageCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBAction func newMessage()
    {
        
    }
    
    override func viewDidLoad()
    {
        api
            .getAllMessages()
            .onSuccess() { messages in
                self.messages = messages
                self.tableView.reloadData()
            }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(messageCellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: messageCellIdentifier)
        }
        cell!.textLabel?.text = messages[indexPath.row].subject
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
}
