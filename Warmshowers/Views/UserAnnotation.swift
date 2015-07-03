//
//  UserAnnotation.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 26/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import MapKit

class UserAnnotation: MKPointAnnotation
{
    var user: User?
    
    init(user: User)
    {
        super.init()
        
        self.user = user
        title = user.fullname
        coordinate = CLLocationCoordinate2D(
            latitude: user.latitude,
            longitude: user.longitude
        )
    }
}
