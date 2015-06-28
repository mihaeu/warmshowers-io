//
//  Feedback.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift

class Feedback: Object
{
    dynamic var id = 0
    dynamic var toUser = User()
    dynamic var fromUser = User()
    
    dynamic var body = ""
    
    dynamic var year = 0
    dynamic var month = 0
    
    dynamic var rating = ""
    dynamic var type = ""
    
    private let FixedRatingValues: Set<String> = ["Positive", "Neutral", "Negative"]
    private let FixedTypeValues: Set<String> = ["Guest", "Host", "Other", "Met Traveling"]
    
    convenience init(id: Int, toUser: User, body: String, year: Int, month: Int, rating: String, type: String)
    {
        self.init()
        
        self.id = id
        self.toUser = toUser
        self.body = body
        
        self.year = year
        self.month = month
        
        self.rating = FixedRatingValues.contains(rating) ? rating : "Positive"
        self.type = FixedTypeValues.contains(type) ? type : "Other"
    }
    
    // MARK: Realm Properties
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    override static func indexedProperties() -> [String]
    {
        return ["toUser"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["FixedRatingValues", "FixedTypeValues"]
    }
}
