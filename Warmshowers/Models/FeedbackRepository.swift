//
//  FeedbackRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 28/06/15.
//  Copyright (c) 2015 Michael haeuslmann. All rights reserved.
//

import BrightFutures
import RealmSwift

class FeedbackRepository
{
    private let api = API.sharedInstance
    
    func getAllById(userId: Int) -> Future<[Feedback], NSError>
    {
        return api.getFeedbackForUser(userId);
    }
    
    func save(feedback: Feedback)
    {
        // if we already have this user in the database, get that one
        var toUserResult = Realm().objects(User).filter("id == \(feedback.toUser.id) && uid > 0")
        
        
        // if we already have this user in the database, get that one
        var fromUserResult = Realm().objects(User).filter("id == \(feedback.fromUser.id) && uid > 0")
        
        Realm().write {
            if toUserResult.count == 1 {
                feedback.toUser = toUserResult.first!
            }
            
            if fromUserResult.count == 1 {
                feedback.fromUser = fromUserResult.first!
            }
            
            Realm().add(feedback, update: true)
        }
    }
}
