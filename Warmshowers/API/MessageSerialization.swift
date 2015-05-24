//
//  MessageSerialization.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import SwiftyJSON

public class MessageSerialization
{
    public static func deserializeJSON(json: JSON) -> Message
    {
        var users = [User]()
        for (key, user) in json["participants"] {
            users.append(User(uid: user["uid"].intValue, name: user["name"].stringValue))
        }
        
        var message = Message(
            threadId: json["thread_id"].intValue,
            subject: json["subject"].stringValue
        )
        
        message.participants = users
        message.count = json["count"].intValue
        message.isNew = json["is_new"].boolValue
        message.lastUpdatedTimestamp = json["last_updated"].intValue
        message.threadStartedTimestamp = json["thread_started"].intValue
        
        message.body = json["body"].string
        
        return message
    }
}