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
        var message = Message()
        
        message.threadId = json["thread_id"].intValue
        message.subject = json["subject"].stringValue
        message.body = json["body"].stringValue

        message.count = json["count"].intValue
        message.isNew = json["is_new"].boolValue
        message.lastUpdatedTimestamp = json["last_updated"].intValue
        message.threadStartedTimestamp = json["thread_started"].intValue

        for (key, userJSON) in json["participants"] {
            message.participants = User(
                id: userJSON["uid"].intValue,
                username: userJSON["name"].stringValue
            )
        }
        
        return message
    }
}