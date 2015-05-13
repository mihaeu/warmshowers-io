//
//  User.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class User
{
    var uid: Int
    var name: String
    var longitude: Double?
    var latitude: Double?
    
    init(uid: Int, name: String)
    {
        self.uid = uid
        self.name = name
    }
}
