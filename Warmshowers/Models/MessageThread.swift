//
//  MessageThread.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

public class MessageThread
{
    var id: Int
    var readAll: Bool?
    var to: Int?
    var messageCount: Int?
    var from: Int?
    var start: Int?
    
    var user: User?
    var messages: [Message]?
    var subject: String?
    var participants: [User]?
    
    // TODO: init ...
    init(id: Int)
    {
        self.id = id
    }
}
