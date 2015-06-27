//
//  Storyboard.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 07/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

struct Storyboard
{
    // Segues
    static let ShowStartSegue = "Show Start"
    static let ShowLogin = "Show Login"
    static let ShowOtherProfileSegue = "Show Other Profile"
    static let ShowMessageThreadSegue = "Show Message Thread"
    static let ShowNewMessageSegue = "Show New Message"
    static let ShowNewFeedbackSegue = "Show New Feedback"
    
    // Identifiers
    static let AnnotationViewReuseIdentifier = "OtherUser"
    static let FavoriteCellIdentifier = "Favorite Cell"
    static let FeedbackCellIdentifier = "Feedback Cell"
    static let MessageCellIdentifier = "Message Cell"
    static let MessageBodyFromCellIdentifier = "Message Body From Cell"
    static let MessageBodyToCellIdentifier = "Message Body To Cell"
    static let ProfileOverviewCellIdentifier = "Profile Overview Cell"
    static let UserCellIdentifier = "User Cell"
    
    // UI
    static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
    
    // Colors
    static let DarkPrimaryColor = "#1976D2"
    static let PrimaryColor = "#2196F3"
    static let LightPrimaryColor = "#BBDEFB"
    static let TextItemColor = "#FFFFFF"
    static let AccentColor = "#03A9F4"
    static let PrimaryTextColor = "#212121"
    static let SecondaryTextColor = "#727272"
    static let DividerColor = "#B6B6B6"
    
    static let DefaultUserThumbnail = UIImage(named: "no-image-64")
    static let DefaultUserPicture = UIImage(named: "no-image-512")
}
