//
//  BaseRepository.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 04/07/15.
//  Copyright (c) 2015 Michael haeuslmann. All rights reserved.
//

import IJReachability

/// Base Class for all repositories
class BaseRepository
{
    var cacheTTL = 60
    var lastUpdated = NSDate(timeIntervalSince1970: 0)

    /**
        Checks whether to get the cached version or fetch a new version.

        :param: refresh

        :returns: true if it's ok to return the cached value
    */
    func cacheIsValid(refresh: Bool) -> Bool
    {
        let ttlNotExpired = cacheTTL > NSDate.secondsBetween(date1: lastUpdated, date2: NSDate())

        return canGetLocal(refresh) && ttlNotExpired
    }

    /**
        Checks whether it's possible to get the data from the local db or not.

        :param: refresh

        :returns: true if we should get the local data
    */
    func canGetLocal(refresh: Bool) -> Bool
    {
        let isNotConnected = !(IJReachability.isConnectedToNetwork())
        let noForcedRefresh = !(refresh)

        return isNotConnected || noForcedRefresh
    }
}
