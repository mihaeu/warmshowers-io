//
//  Message.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift

public class Message: Object
{
    dynamic var id = 0
    dynamic var threadId = 0
    dynamic var subject = ""
    
    dynamic var count = 0
    dynamic var isNew = false
    dynamic var participants: User?
    
    dynamic var timestamp = 0
    dynamic var lastUpdatedTimestamp = 0
    dynamic var threadStartedTimestamp = 0
    
    dynamic var author: User?
    dynamic var body = ""

    // -------------------------------------------------------------------------
    // MARK: Realm Properties
    // -------------------------------------------------------------------------

    override public static func primaryKey() -> String?
    {
        return "id"
    }
}
