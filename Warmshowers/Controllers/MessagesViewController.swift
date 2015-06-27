//
//  MessagesViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import Haneke

let iconFormat = Format<UIImage>(name: "thumbnail", diskCapacity: 10 * 1024 * 1024) { image in
    return image
}

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    private let messageRepository = MessageRepository()
    private let userRepository = UserRepository()
    private var messages = [Message]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        messageRepository.getAll().onSuccess() { messages in
            self.messages = messages
            self.tableView.reloadData()
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowMessageThreadSegue {
            if let messageThreadViewController = segue.destinationViewController as? MessageThreadViewController {
                if let messageThreadId = sender as? Int {
                    messageThreadViewController.threadId = messageThreadId
                }
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let messageThreadId = messages[indexPath.row].threadId
        performSegueWithIdentifier(Storyboard.ShowMessageThreadSegue, sender: messageThreadId)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MessageCellIdentifier) as? MessageCell
        if cell == nil {
            cell = MessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.MessageCellIdentifier)
        }
    
        let authors = messages[indexPath.row].participants
        
        if authors != nil && authors!.count > 0 {
            cell?.userPictureImageView.hnk_setImageFromURL(
                User.thumbnailURLFromId(authors!.first!.uid),
                placeholder: Storyboard.DefaultUserThumbnail,
                format: iconFormat
            )
            userRepository.findById(authors!.first!.uid).onSuccess() { user in
                cell?.usernameLabel.text = user.fullname
            }
        }

        cell?.subjectLabel.text = messages[indexPath.row].subject
        cell?.sizeToFit()
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
}
