//
//  UserSearch.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class UserSearch
{
    func byLocation(longitude: Double, latitude: Double) -> [User]
    {
        var user1 = MockData.User1
        user1.longitude = MockData.User1Latitude
        user1.latitude = MockData.User1Longitude
        
        var user2 = MockData.User2
        user2.longitude = MockData.User2Latitude
        user2.latitude = MockData.User2Longitude
        
        return [user1, user2]
    }
}