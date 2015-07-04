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

/// A central place for fetching and caching messages.
class MessageRepository: BaseRepository
{
    static var sharedInstance = MessageRepository(api: API.sharedInstance)

    private var api: API!

    /**
        Inject API so it can be mocked.

        Call this only when testing, use the sharedInstance otherwise.

        :param: api	API
    */
    convenience init(api: API)
    {
        self.init()

        self.api = api
    }

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
            promise.failure(Error.NoInternet)
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

        :param: refresh If true will always check the API when possible.

        :returns: messages on success, error on failure
    */
    func getAll(refresh: Bool = false) -> Future<[Message], NSError>
    {
        // if offline, retrieve cached messages or return empty messages
        if cacheIsValid(refresh) {
            let result = Realm().objects(Message)
            var messages = [Message]()
            for message in result {
                messages.append(message)
            }
            let promise = Promise<[Message], NSError>()
            promise.success(messages)

            log.debug("Fetching messages from cache, found \(messages.count)")
            return promise.future
        }

        // cache and return
        return api.getAllMessages().onSuccess { messages in
            self.lastUpdated = NSDate()
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
