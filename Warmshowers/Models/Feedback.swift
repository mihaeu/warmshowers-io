//
//  Feedback.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class Feedback
{  
    var toUser: User
    var fromUser = User()
    
    var body: String
    
    var year: Int
    var month: Int
    
    var rating: String
    var type: String
    
    let FixedRatingValues: Set<String> = ["Positive", "Neutral", "Negative"]
    let FixedTypeValues: Set<String> = ["Guest", "Host", "Other", "Met Traveling"]
    
    init(toUser: User, body: String, year: Int, month: Int, rating: String, type: String)
    {
        self.toUser = toUser
        self.body = body
        
        self.year = year
        self.month = month
        
        self.rating = FixedRatingValues.contains(rating) ? rating : "Positive"
        self.type = FixedTypeValues.contains(type) ? type : "Other"
    }
}
