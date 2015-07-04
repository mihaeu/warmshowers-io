//
//  UserAnnotationView.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 03/07/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import MapKit

class UserAnnotationView: MKPinAnnotationView
{
    func updateUserInfo(user: User)
    {
        canShowCallout = true
        animatesDrop = true

        var leftCalloutFrame = UIImageView(frame: Storyboard.LeftCalloutFrame)
        UserPictureCache.sharedInstance.thumbnailById(user.id)
            .onSuccess { image in
                leftCalloutFrame.image = image
            }.onFailure { error in
                leftCalloutFrame.image = UserPictureCache.defaultThumbnail
            }
        leftCalloutAccessoryView = leftCalloutFrame

        rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
    }
}
