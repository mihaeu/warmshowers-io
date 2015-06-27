//
//  Utils.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 26/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class Utils
{
    static func htmlToAttributedText(html: String) -> NSAttributedString
    {
        return NSAttributedString(
            data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil
        )!
    }
    
    static func longDateFromTimestamp(timestamp: Int) -> String
    {
        let lastMessageDate = NSDate(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a d MMMM yyyy"
        return dateFormatter.stringFromDate(lastMessageDate)
    }
}
