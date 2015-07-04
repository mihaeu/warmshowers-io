//
//  FeedbackCell.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 26/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class FeedbackCell: UITableViewCell
{
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!

    convenience init()
    {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.FeedbackCellIdentifier)
    }

    func update(feedback: Feedback)
    {
        userLabel.text = "\(feedback.fromUser.fullname)"
        feedbackLabel.attributedText = Utils.htmlToAttributedText(feedback.body)
        createdOnLabel.text = "\(feedback.rating) feedback written in \(Constants.Months[feedback.month]!) \(feedback.year)"

        UserPictureCache.sharedInstance.thumbnailById(feedback.fromUser.id).onSuccess { image in
            self.userPictureImageView.image = image
        }.onFailure { error in
            self.userPictureImageView.image = UserPictureCache.defaultThumbnail
        }
    }
}
