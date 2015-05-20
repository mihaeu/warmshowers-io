//
//  Feedback.swift
//  Warmshowers
//
//  Created by admin on 20/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

public class Feedback
{  
    var userForFeedback: String
    var userIdForFeedback: Int
    var body: String
    var year: Int
    var month: Int
    var rating: String
    var type: String
    
    static let RatingPositive = "Positive"
    static let RatingNegative = "Negative"
    static let RatingNeutral = "Neutral"
    
    static let TypeGuest = "Guest"
    static let TypeHost = "Host"
    static let TypeMetTraveling = "Met Traveling"
    static let TypeOther = "Other"
    
    public init(userIdForFeedback: Int, userForFeedback: String, body: String, year: Int, month: Int, rating: String, type: String)
    {
        self.userIdForFeedback = userIdForFeedback
        self.userForFeedback = userForFeedback
        self.body = body
        self.year = year
        self.month = month
        
        if rating == Feedback.RatingPositive || rating == Feedback.RatingNegative || rating == Feedback.RatingNeutral {
            self.rating = rating
        } else {
            self.rating = Feedback.RatingPositive
        }
        
        if type == Feedback.TypeGuest || type == Feedback.TypeHost || type == Feedback.TypeMetTraveling || type == Feedback.TypeOther {
            self.type = type
        } else {
            self.type = Feedback.TypeOther
        }
    }
}
