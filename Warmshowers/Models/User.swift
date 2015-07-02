//
//  User.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 19/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift

public class User: Object
{
    dynamic var id = 0
    dynamic var username = ""

    convenience init(id: Int, username: String)
    {
        self.init()
        
        self.id = id
        self.username = username
    }
    
    // this is only set for the logged in user
    dynamic var password = ""
    
    dynamic var comments = ""
    dynamic var fullname = ""
    
    dynamic var picture = ""
    
    dynamic var spokenLanguages = ""
    
    dynamic var street = ""
    dynamic var city = ""
    dynamic var zipCode = ""
    dynamic var country = ""
    
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    dynamic var isFavorite = false

    dynamic var timeCached = NSDate(timeIntervalSince1970: 1)
    
    // -------------------------------------------------------------------------
    // MARK: Realm Properties
    // -------------------------------------------------------------------------
    
    override public static func primaryKey() -> String?
    {
        return "id"
    }
    
    override public static func indexedProperties() -> [String]
    {
        return ["username", "fullname", "city", "password"]
    }
}
