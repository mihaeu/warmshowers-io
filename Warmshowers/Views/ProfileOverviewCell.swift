//
//  ProfileOverviewCell.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 27/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class ProfileOverviewCell: UITableViewCell
{
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    convenience init()
    {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.ProfileOverviewCellIdentifier)
    }

    func update(user: User)
    {
        fullnameLabel.text = user.fullname
        descriptionLabel.attributedText = Utils.htmlToAttributedText(user.comments)

        UserPictureCache.sharedInstance.pictureById(user.id).onSuccess { image in
            self.userPictureImageView.image = image
        }.onFailure { error in
            self.userPictureImageView.image = UserPictureCache.defaultPicture
        }
    }
}
