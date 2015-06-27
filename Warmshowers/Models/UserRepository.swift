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
    private let api = API.sharedInstance
    
    func findById(id: Int, refresh: Bool = false) -> Future<User, NSError>
    {
//        if refresh == false {
//            let result = Realm().objects(User).filter("uid = \(id)")
//            if result.count == 1 {
//                var futureUser = future { () -> Result<User> in
//                    return .Success(Box(result.first!))
//                }
//            }
//        }
        
        return api.getUser(id)
    }
    
    func findByLocation(minlat: Double, maxlat: Double, minlon: Double, maxlon: Double, centerlat: Double, centerlon: Double, limit: Int) -> Future<[Int:User], NSError>
    {
        return api.searchByLocation(minlat, maxlat: maxlat, minlon: minlon, maxlon: maxlon, centerlat: centerlat, centerlon: centerlon, limit: limit)
    }
    
    func findByFavorite() -> [User]
    {
        var users = [User]()
        for user in Realm().objects(User).filter("isFavorite == true") {
            users.append(user)
        }
        return users
    }
    
    func findByActiveUser() -> User?
    {
        let result = Realm().objects(User).filter("password != ''")
        return result.first!
    }
    
    func save(user: User)
    {
        Realm().write {
            Realm().add(user, update: true)
        }
    }
    
    func update(user: User, key: String, value: AnyObject?)
    {
        Realm().write {
            user.setValue(value, forKey: key)
        }
    }
}
