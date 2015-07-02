//
//  UserRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 25/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import BrightFutures
import RealmSwift
import Result
import Box

class UserRepository
{
    private let api = API.sharedInstance

    /**
        Fetches the user from either local storage or from the internet.
    
        The result is wrapped either way, since it is not clear whether the
        outcome is syncronous or asynchronous.

        :param: id      User Id
        :param: refresh When true fetches the User fromt the API (Default: false)

        :returns: User on success, Error on failure
    */
    func findById(id: Int, refresh: Bool = false) -> Future<User, NSError>
    {
        let result = Realm().objects(User).filter("id == \(id)")
        var localUser = User()

        if refresh == false {
            if result.count == 1 {
                let promise = Promise<User, NSError>()
                localUser = result.first!
                promise.success(localUser)
                return promise.future
            }
        }

        // before returning save the result locally
        let future = api.getUser(id).onSuccess { user in
            Realm().write {
                // the favorite flag of a user is only saved locally and is
                // not supported by the API, thus we need to transfer the
                // flag from the local result (if it doesn't exist, it
                // is false anyways)
                user.isFavorite = localUser.isFavorite
                Realm().add(user, update: true)
            }
        }
        return future
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
        return result.first
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
