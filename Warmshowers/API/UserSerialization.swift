//
//  UserSerialization.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import SwiftyJSON

public class UserSerialization
{
    public static func deserializeJSON(json: JSON) -> User
    {
        var user = User()
        user.uid = json["uid"].intValue
        user.name = json["name"].stringValue
        
        user.picture = json["picture"].stringValue
        user.languagesspoken = json["languagesspoken"].stringValue
        user.latitude = json["latitude"].doubleValue
        user.longitude = json["longitude"].doubleValue
        user.comments = json["comments"].stringValue
        user.fullname = json["fullname"].stringValue
        
        return user
    }
}
