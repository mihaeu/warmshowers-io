//
//  FeedbackRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 28/06/15.
//  Copyright (c) 2015 Michael haeuslmann. All rights reserved.
//

import BrightFutures
import RealmSwift
import IJReachability

/// A central place for fetching and caching Feedback
class FeedbackRepository: BaseRepository
{
    /// Singleton
    static var sharedInstance = FeedbackRepository(api: API.sharedInstance)

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
        Get all feedback for a user.
        
        This will always fetch live feedback unless the phone is not connected
        to the internet, in which case it tries to find a cached version and
        returns nothing (but succeeds).

        :param: userId
    
        :param: refresh If true will always check the API when possible.

        :returns: array of feedback on success, error on failure
    */
    func getAllByUser(user: User, refresh: Bool = false) -> Future<[Feedback], NSError>
    {
        let result = Realm().objects(Feedback).filter("toUserId == \(user.id)")

        // only check db, when not connected
        if result.count > 0 && canGetLocal(refresh) {
            let promise = Promise<[Feedback], NSError>()
            var userFeedback = [Feedback]()
            for feedback in result {
                userFeedback.append(feedback)
            }
            log.debug("Fetching feedback from cache, found \(userFeedback.count)")
            promise.success(userFeedback)
            return promise.future
        }

        // fetch and cache
        return api.getFeedbackForUser(user.id).onSuccess { userFeedback in
            self.lastUpdated = NSDate()
            for feedback in userFeedback {
                self.save(feedback)
            }
        }
    }

    /**
        Save new feedback.

        :param: feedback
    */
    func save(feedback: Feedback)
    {
        // we have to fetch the full user object, because otherwise Realm will
        // overwrite the existing user with a possibly sparse one

        // if we already have this user in the database, get that one
        var toUserResult = Realm().objects(User).filter("id == \(feedback.toUser.id) && id > 0")
        
        // if we already have this user in the database, get that one
        var fromUserResult = Realm().objects(User).filter("id == \(feedback.fromUser.id) && id > 0")
        
        Realm().write {
            if toUserResult.count == 1 {
                feedback.toUser = toUserResult.first!
            }
            feedback.toUserId = feedback.toUser.id
            
            if fromUserResult.count == 1 {
                feedback.fromUser = fromUserResult.first!
            }
            
            Realm().add(feedback, update: true)
        }
    }
}
