//
//  Feedback.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import RealmSwift
import Foundation

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
    
    private let RatingValues: Set<String> = ["Positive", "Neutral", "Negative"]
    private let TypeValues: Set<String> = ["Guest", "Host", "Other", "Met Traveling"]
    
    convenience init(id: Int, toUser: User, body: String, year: Int, month: Int, rating: String, type: String)
    {
        self.init()
        
        self.id = id
        self.toUser = toUser
        self.body = body
        
        self.year = year
        self.month = month
        
        self.rating = RatingValues.contains(rating) ? rating : "Positive"
        self.type = TypeValues.contains(type) ? type : "Other"
    }
    
    convenience init(id: Int, toUser: User, body: String, date: NSDate, rating: String, type: String)
    {
        self.init(id: id, toUser: toUser, body: body, year: date.month, month: date.month, rating: rating, type: type)
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
        return ["RatingValues", "TypeValues"]
    }
}
