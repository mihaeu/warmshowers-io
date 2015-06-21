//
//  User.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 19/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift

public class User: Object
{
    dynamic var uid = 0
    dynamic var name = ""
    
    convenience init(uid: Int, name: String) {
        self.init()
        self.uid = uid
        self.name = name
    }
    
    // this is only set for the logged in user
    dynamic var password = ""
    dynamic var comments = ""
    
    dynamic var picture = ""
    
    var thumbnailURL: String {
        var thumbnailURL = "https://www.warmshowers.org/files/imagecache/map_infoWindow/files/default_picture.jpg"
        
        if picture != "" {
            var urlParts = split(picture) { $0 == "/" }
            let thumbnailURL = "https://www.warmshowers.org/" + urlParts.removeAtIndex(0) + "/imagecache/profile_picture/" + "/".join(urlParts)
            return thumbnailURL
        }
        
        return thumbnailURL;
    }
    
    dynamic var languagesspoken = ""
    
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    dynamic var isFavorite = false
    
    override public static func primaryKey() -> String?
    {
        return "uid"
    }
    
    override public static func indexedProperties() -> [String]
    {
        return ["name", "email"]
    }
}
