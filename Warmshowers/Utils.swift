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
        E.g. 7:00 AM 12 December 2014
    */
    static func longDateFromTimestamp(timestamp: Int) -> String
    {
        let lastMessageDate = NSDate(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a d MMMM yyyy"
        return dateFormatter.stringFromDate(lastMessageDate)
    }
    
    /**
        Checks whether the phone has access to the internet or not.
    
        Taken from http://stackoverflow.com/questions/25398664/check-for-internet-connection-availability-in-swift
    
        :returns: Bool
    */
    static func phoneIsConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return isReachable && !needsConnection
    }
}
