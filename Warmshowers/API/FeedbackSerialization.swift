//
//  FeedbackSerialization.swift
//  Warmshowers
//
//  Created by admin on 23/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import SwiftyJSON

public class FeedbackSerialization
{
    public static func deserializeJSON(json: JSON) -> Feedback
    {
        var year = 0
        var month = 0
        (year, month) = self.extractYearMonthFromTimestamp(json["field_hosting_date_value"].doubleValue)
        
        var feedback = Feedback(
            userIdForFeedback: json["uid_1"].intValue,
            userForFeedback: json["name_1"].stringValue,
            body: json["body"].stringValue,
            year: year,
            month: month,
            rating: json["field_rating_value"].stringValue,
            type: json["field_guest_or_host_value"].stringValue
        )

        return feedback
    }
    
    public static func extractYearMonthFromTimestamp(timestamp: Double) -> (Int,Int)
    {
        let date = NSDate(timeIntervalSince1970: timestamp)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let year = components.year
        let month = components.month
        
        return (year, month)
    }
}
