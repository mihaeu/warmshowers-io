//
//  FeedbackSerialization.swift
//  Warmshowers
//
//  Created by admin on 23/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import SwiftyJSON

class FeedbackSerialization
{
    let FixedRatingValues: Set<String> = ["Positive", "Neutral", "Negative"]
    let FixedTypeValues: Set<String> = ["Guest", "Host", "Met Traveling", "Other"]
    
    static func deserializeJSON(json: JSON) -> Feedback
    {
        var year = 0
        var month = 0
        (year, month) = self.extractYearMonthFromTimestamp(json["field_hosting_date_value"].doubleValue)
                
        var feedback = Feedback(
            id: json["nid"].intValue,
            toUser: User(id: json["uid_1"].intValue, username: json["name_1"].stringValue),
            body: json["body"].stringValue,
            year: year,
            month: month,
            rating: json["field_rating_value"].stringValue,
            type: json["field_guest_or_host_value"].stringValue
        )
        
        var fromUser = User(id: json["uid"].intValue, username: json["name"].stringValue)
        fromUser.fullname = json["fullname"].stringValue
        feedback.fromUser = fromUser
        
        return feedback
    }
    
    static func extractYearMonthFromTimestamp(timestamp: Double) -> (Int,Int)
    {
        let date = NSDate(timeIntervalSince1970: timestamp)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let year = components.year
        let month = components.month
        
        return (year, month)
    }
}
