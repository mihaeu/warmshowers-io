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
    private var api = API.sharedInstance
    private var messageThread: MessageThread?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 160
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
        let message = messageThread?.messages![indexPath.row]
        var cell: MessageBodyCell?
        
        // I am sending the message
        if messageThread?.user?.uid == message?.author?.uid {
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MessageBodyToCellIdentifier) as? MessageBodyCell
            if cell == nil {
                cell = MessageBodyCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.MessageBodyToCellIdentifier)
            }
        // someone sent the message to me
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MessageBodyFromCellIdentifier) as? MessageBodyCell
            if cell == nil {
                cell = MessageBodyCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.MessageBodyFromCellIdentifier)
            }
        }

        cell?.bodyLabel.attributedText = NSAttributedString(
            data: message!.body!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil
        )
        
        api.getUser(message!.author!.uid).onSuccess() { user in
            let url = NSURL(string: user.thumbnailURL)!
            cell?.userPictureImageView.hnk_setImageFromURL(url)
        }
        
        return cell!
    }
}
