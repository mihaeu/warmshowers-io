//
//  User.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class User
{
    var id: Int
    var name: String
    var longitude: Double?
    var latitude: Double?
    
    init(id: Int, name: String)
    {
        self.id = id
        self.name = name
    }
}
