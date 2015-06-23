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
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 160.0
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
        
        let messageBody = messageThread?.messages![indexPath.row].body
        cell?.textLabel!.attributedText = NSAttributedString(
            data: messageBody!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil
        )

        cell?.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell?.textLabel!.numberOfLines = 0
        
        return cell!
    }
}
