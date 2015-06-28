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
    dynamic var uid = 0
    dynamic var name = ""
    
    convenience init(uid: Int, name: String)
    {
        self.init()
        
        self.uid = uid
        self.name = name
    }
    
    // this is only set for the logged in user
    dynamic var password = ""
    
    dynamic var comments = ""
    dynamic var fullname = ""
    
    dynamic var picture = ""
    
    dynamic var languagesspoken = ""
    
    dynamic var street = ""
    dynamic var city = ""
    dynamic var zipCode = ""
    dynamic var country = ""
    
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    dynamic var isFavorite = false
    
    
    // MARK: Realm Properties
    
    override public static func primaryKey() -> String?
    {
        return "uid"
    }
    
    override public static func indexedProperties() -> [String]
    {
        return ["name", "fullname", "city", "password"]
    }
}
