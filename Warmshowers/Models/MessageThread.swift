//
//  MessageThread.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift

public class MessageThread: Object
{
    dynamic var id = 0
    dynamic var readAll = true
    dynamic var to = 0
    dynamic var messageCount = 0
    dynamic var from = 0
    dynamic var start = 0
    
    dynamic var user: User?
    var messages = List<Message>()
    dynamic var subject = ""
    var participants = List<User>()

    convenience init(id: Int)
    {
        self.init()

        self.id = id
    }
    
    // -------------------------------------------------------------------------
    // MARK: Realm Properties
    // -------------------------------------------------------------------------

    override public static func primaryKey() -> String?
    {
        return "id"
    }
}
