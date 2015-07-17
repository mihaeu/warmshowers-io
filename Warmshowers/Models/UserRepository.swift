//
//  UserRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 25/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import IJReachability
import BrightFutures
import RealmSwift
import Result
import Box

/// A central place for fetching and caching users.
class UserRepository: BaseRepository
{
    /// Singleton
    static var sharedInstance = UserRepository(api: API.sharedInstance)

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
        Fetches the user from either local storage or from the internet.
    
        The result is wrapped either way, since it is not clear whether the
        outcome is syncronous or asynchronous.

        :param: id      User Id
        :param: refresh When true fetches the User fromt the API (Default: false)

        :returns: User on success, Error on failure
    */
    func findById(id: Int, refresh: Bool = false) -> Future<User, NSError>
    {
        // sparse users have only id and username (e.g. from a search by keyword or
        // location, in that case we don't want the user
        let result = Realm().objects(User).filter("id == \(id) AND comments != ''")
        var localUser = result.first

        if result.count == 1 && canGetLocal(refresh) {
            let promise = Promise<User, NSError>()
            promise.success(localUser!)
            log.debug("Fetching user from cache, found \(localUser!.username)")
            return promise.future
        }

        // before returning save the result locally
        let future = api.getUser(id).onSuccess { user in
            self.lastUpdated = NSDate()
            Realm().write {
                // the favorite flag of a user is only saved locally and is
                // not supported by the API, thus we need to transfer the
                // flag from the local result (if it doesn't exist, it
                // is false anyways)
                if localUser != nil {
                    user.isFavorite = localUser!.isFavorite
                }
                Realm().add(user, update: true)
            }
        }
        return future
    }

    /**
        Fetches users within the given area.
        
        If there are more users in the area than the limit (or the limit of the API
        which is ~800) only the limit will be returned and those users will all
        be centered around the center.

        :param: minLatitude     South-West latitude
        :param: maxLatitude     North-East latitude
        :param: minLongitude    South-West longitude
        :param: maxLongitude    North-East longitude
        :param: centerLatitude	Center latitude
        :param: centerLongitude	Center longitude
        :param: limit           Max. users (greatly influences response time)

        :returns: User dictionary on success, Error on failure
    */
    func findByLocation(
        minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double,
        centerLatitude: Double,
        centerLongitude: Double,
        limit: Int) -> Future<[Int:User], NSError>
    {
        return api.searchByLocation(
            minLatitude,
            maxlat: maxLatitude,
            minlon: minLongitude,
            maxlon: maxLongitude,
            centerlat: centerLatitude,
            centerlon: centerLongitude,
            limit: limit
        )
    }

    /**
        Search for users by username, fullname or city.

        :param: keyword
        :param: limit

        :returns: Future<[Int:User]>
    */
    func searchByKeyword(keyword: String, limit: Int) -> Future<[Int:User], NSError>
    {
        return api.searchByKeyword(keyword, limit: limit)
    }

    /**
        Find all users which have been favorited.

        :returns: User array
    */
    func findByFavorite() -> [User]
    {
        var users = [User]()
        for user in Realm().objects(User).filter("isFavorite == true") {
            users.append(user)
        }
        return users
    }

    /**
        Find the currently logged in User and registers the user with the API.

        :returns: User
    */
    func findByActiveUser() -> User?
    {
        let result = Realm().objects(User).filter("password != ''")
        if result.first != nil {
            api.loggedInUser = result.first
        }
        return result.first
    }

    /**
        Saves/Updates the whole user object.

        :param: user	User
    */
    func save(user: User)
    {
        // sometimes the API handles corrupt users
        if user.id == 0 {
            return
        }

        Realm().write {
            Realm().add(user, update: true)
        }
    }

    /**
        Updates a User property/

        :param: user	User
        :param: key     String
        :param: value	AnyObject?
    */
    func update(user: User, key: String, value: AnyObject?)
    {
        Realm().write {
            user.setValue(value, forKey: key)
        }
    }
}
