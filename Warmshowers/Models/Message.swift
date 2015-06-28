//
//  Message.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

public class Message
{
    var threadId = 0
    var subject = ""
    
    var count: Int?
    var isNew: Bool?
    var participants: [User]?
    
    var timestamp: Int = 0
    var lastUpdatedTimestamp: Int?
    var threadStartedTimestamp: Int?
    
    var author: User?
    var body: String?
    var files: [String]?
}
