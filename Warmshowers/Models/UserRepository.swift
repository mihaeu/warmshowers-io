//
//  UserRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 25/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import BrightFutures
import RealmSwift

class UserRepository
{
    let api = API.sharedInstance
    
    func findById(id: Int, refresh: Bool = false) -> Future<User>
    {
        var user: User
        if refresh == false {
            let result = Realm().objects(User).filter("uid = \(id)")
            if result.count == 1 {
                var futureUser = future { () -> Result<User> in
                    return .Success(Box(result.first!))
                }
            }
        }
        
        return api.getUser(id)
    }
}
