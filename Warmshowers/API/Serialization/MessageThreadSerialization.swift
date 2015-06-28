//
//  MessageThreadSerialization.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import SwiftyJSON

public class MessageThreadSerialization
{
    public static func deserializeJSON(json: JSON) -> MessageThread
    {
        var messageThread = MessageThread(id: json["thread_id"].intValue)
        
        var participants = [User]()
        for (key, userJson) in json["participants"] {
            var user = User(uid: userJson["uid"].intValue, name: userJson["name"].stringValue)
            participants.append(user)
        }
        messageThread.participants = participants
        
        var messages = [Message]()
        for (key, messageJson) in json["messages"] {
            var message = Message()
            message.threadId = messageJson["thread_id"].intValue
            message.subject = messageJson["subject"].stringValue
            message.body = messageJson["body"].stringValue
            message.author = User(uid: messageJson["author"]["uid"].intValue, name: messageJson["author"]["name"].stringValue)
            message.timestamp = messageJson["timestamp"].intValue
            messages.append(message)
        }
        messageThread.messages = messages
        
        var user = User(uid: json["user"]["uid"].intValue, name: json["user"]["name"].stringValue)
        messageThread.user = user
        
        messageThread.readAll = json["read_all"].boolValue
        messageThread.to = json["to"].intValue
        messageThread.messageCount = json["message_count"].intValue
        messageThread.from = json["from"].intValue
        messageThread.start = json["start"].intValue
        messageThread.subject = json["subject"].stringValue
        
        return messageThread
    }
}
