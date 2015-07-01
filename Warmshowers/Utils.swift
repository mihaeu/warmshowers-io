//
//  Utils.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 26/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import SystemConfiguration

class Utils
{
    /**
        Converts basic HTML tags for output to labels. Tested to work with b,i,em,strong,table and a few other basic tags.
        Line feeds are not properly displayed yet.
    
        :param: HTML string
    
        :returns: NSAttributedString
    */
    static func htmlToAttributedText(html: String) -> NSAttributedString
    {
        return NSAttributedString(
            data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil
        )!
    }
    
    /**
        Displays date and time
    */
    static func longDateFromTimestamp(timestamp: Int) -> String
    {
        let date = NSDate(timeIntervalSince1970: Double(timestamp))
        return NSDateFormatter.localizedStringFromDate(
            date,
            dateStyle: NSDateFormatterStyle.MediumStyle,
            timeStyle: NSDateFormatterStyle.ShortStyle
        )

    }
    
    /**
        Displays only month and year
    */
    static func shortDate(date: NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.stringFromDate(date)
    }
}
