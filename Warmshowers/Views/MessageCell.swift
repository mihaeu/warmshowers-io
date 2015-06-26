//
//  MessageCell.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell
{
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    init(message: Message)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.MessageCellIdentifier)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
