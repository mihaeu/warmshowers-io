//
//  MessageRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 24/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import BrightFutures
import RealmSwift
import IJReachability

class MessageRepository
{
    let api = API.sharedInstance

    /**
        Send the message.
        
        Only works if the user is online, otherwise will return an error.

        :param: message
    
        :returns: true on success, error on failure
    */
    func save(message: Message) -> Future<Bool, NSError>
    {
        if !IJReachability.isConnectedToNetwork() {
            let promise = Promise<Bool, NSError>()
            promise.failure(NSError(
                domain: "No internet connection",
                code: 1,
                userInfo: nil
            ))
            return promise.future
        }

        // if the message is from a thread, not
        if message.threadId == 0 {
            return api.sendMessage(message)
        } else {
            return api.replyMessage(message)
        }
    }

    /**
        Get and cache all messages for the current user.

        :returns: messages on success, error on failure
    */
    func getAll() -> Future<[Message], NSError>
    {
        // if offline, retrieve cached messages or return empty messages
        if !IJReachability.isConnectedToNetwork() {
            let result = Realm().objects(Message)
            var messages = [Message]()
            for message in result {
                messages.append(message)
            }
            let promise = Promise<[Message], NSError>()
            promise.success(messages)
            return promise.future
        }

        // cache and return
        return api.getAllMessages().onSuccess { messages in
            for message in messages {
                // check if the user already exists, because otherwise
                // Realm will overwrite the existing user with the user provided
                // as author
                if message.author != nil {
                    let result = Realm().objects(User).filter("id == \(message.author!.id)")
                    if result.count == 1 {
                        message.author = result.first
                    }
                }

                // this is a pseudo id that is only relevant for caching
                // the property won't change and it's very unlikely that there
                // are two with the same value
                message.id = message.threadStartedTimestamp
                Realm().write {
                    Realm().add(message, update: true)
                }
            }
        }
    }
}
