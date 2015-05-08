//
//  UserSearch.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class UserSearch
{
    /**
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#bylocation
    
        :param: Double Logitude of current user.
        :param: Double Latitude of current user.
    
        :returns: [User]
    */
    func byLocation(latitude: Double, longitude: Double) -> [User]
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