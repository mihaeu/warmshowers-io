//
//  MessageThreadSerialization.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import SwiftyJSON
import RealmSwift

public class MessageThreadSerialization
{
    public static func deserializeJSON(json: JSON) -> MessageThread
    {
        var messageThread = MessageThread(id: json["thread_id"].intValue)
        
        var participants = List<User>()
        for (key, userJson) in json["participants"] {
            var user = User(id: userJson["uid"].intValue, username: userJson["name"].stringValue)
            participants.append(user)
        }

        messageThread.participants = participants
        
        var messages = List<Message>()
        for (key, messageJson) in json["messages"] {
            var message = Message()
            message.id = messageJson["mid"].intValue
            message.threadId = messageJson["thread_id"].intValue
            message.subject = messageJson["subject"].stringValue
            message.body = messageJson["body"].stringValue

            message.author = User(
                id: messageJson["author"]["uid"].intValue,
                username: messageJson["author"]["name"].stringValue
            )

            let result = Realm().objects(User).filter("id == \(message.author!.id)")
            if result.count == 1 {
                message.author = result.first!
            }
            message.timestamp = messageJson["timestamp"].intValue
            messages.append(message)
        }
        messageThread.messages = messages
        
        var user = User(id: json["user"]["uid"].intValue, username: json["user"]["name"].stringValue)
        let result = Realm().objects(User).filter("id == \(user.id)")
        if result.count == 1 {
            user = result.first!
        }
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
