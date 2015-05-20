//
//  Message.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

public class Message
{
    var threadId: Int
    var subject: String
    
    var count: Int
    var isNew: Bool
    var participants: [User]
    
    var lastUpdatedTimestamp: Int
    var threadStartedTimestamp: Int
    
    init(threadId: Int, subject: String, participants: [User], count: Int, isNew: Bool, lastUpdatedTimestamp: Int, threadStartedTimestamp: Int)
    {
        self.threadId = threadId
        self.subject = subject
        
        self.count = count
        self.isNew = isNew
        self.participants = participants
        
        self.lastUpdatedTimestamp = lastUpdatedTimestamp
        self.threadStartedTimestamp = threadStartedTimestamp
    }    
}
