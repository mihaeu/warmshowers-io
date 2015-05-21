//
//  MessageThreadViewController.swift
//  Warmshowers
//
//  Created by admin on 20/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit

class MessageThreadViewController: UIViewController, UITableViewDataSource
{
    private var api = API()
    private var messageThread: MessageThread?
    
    private let messageCell = "messageCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    var threadId: Int? {
        didSet {
            api
                .readMessageThread(threadId!)
                .onSuccess() { messageThread in
                    self.messageThread = messageThread
                    self.tableView.reloadData()
                }
        }
    }
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Conversation"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Reply,
            target: self,
            action: "replyToThread"
        )
    }
    
    func replyToThread()
    {
        performSegueWithIdentifier(Storyboard.ShowNewMessageSegue, sender: messageThread)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowNewMessageSegue {
            if let destinationViewController = segue.destinationViewController as? NewMessageViewController {
                if let messageThreadForReply = sender as? MessageThread {
                    destinationViewController.messageThread = messageThreadForReply
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageThread?.messageCount ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(messageCell) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell()
        }
        cell?.textLabel?.text = messageThread?.messages![0].body
        return cell!
    }
}
