//
//  MessageThreadRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 03/07/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift
import BrightFutures
import IJReachability

/// A central place for fetching and caching message repositories.
class MessageThreadRepository
{
    static var sharedInstance = MessageThreadRepository(api: API.sharedInstance)

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
        Fetch a message thread from the API or from local storage when offline.

        :param: threadId

        :returns: message thread on success, error on failure
    */
    func findById(threadId: Int) -> Future<MessageThread, NSError>
    {
        // messages should always be up to date, so only get the local version
        // when there is no other choice
        if !IJReachability.isConnectedToNetwork() {
            let result = Realm().objects(MessageThread).filter("id == \(threadId)")
            let promise = Promise<MessageThread, NSError>()
            if result.count == 1 {
                promise.success(result.first!)
            } else {
                promise.failure(NSError(
                    domain: "No internet connection",
                    code: 1,
                    userInfo: nil
                ))
            }
            return promise.future
        }

        // fetch and cache
        return api.readMessageThread(threadId).onSuccess { messageThread in
            Realm().write {
                // realm will replace existing users with participants users
                // which have only sparse data, thus fetch and replace users
                // for the result
                var index = 0
                for user in messageThread.participants {
                    let result = Realm().objects(User).filter("id == \(user.id)")
                    if result.count == 1 {
                        messageThread.participants.replace(index, object: result.first!)
                    }
                    ++index
                }
                Realm().add(messageThread, update: true)
            }
        }
    }
}
