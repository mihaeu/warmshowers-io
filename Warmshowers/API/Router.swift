//
//  Router.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible
{
    static let baseURLString = "https://www.warmshowers.org"
    
    case Login(username: String, password: String)
    case Logout(username: String, password: String)
    
    case ReadUser(userId: Int)
    case SearchByKeyword(keyword: String, limit: Int, page: Int)
    case SearchByLocation(minlat: Double, maxlat: Double, minlon: Double, maxlon: Double, centerlat: Double, centerlon: Double, limit: Int)
    
    case ReadFeedback(userId: Int)
    case CreateFeedback(feedback: Feedback)
    
    case ReadMessages
    case GetUnreadMessageCount
    case ReadMessageThread(threadId: Int)
    case MarkMessageThread(threadId: Int, unread: Bool)
    case SendMessage(message: Message)
    case ReplyMessage(message: Message)
    
    var path: String {
        switch self {
            case .Login:
                return "/services/rest/user/login"
            case .Logout:
                return "/services/rest/user/logout"
            
            case .ReadUser(let userId):
                return "/services/rest/user/\(userId)"
            case .SearchByKeyword:
                return "/services/rest/hosts/by_keyword"
            case .SearchByLocation:
                return "/services/rest/hosts/by_location"
            
            case .ReadFeedback(let userId):
                return "/user/\(userId)/json_recommendations"
            case .CreateFeedback:
                return "/services/rest/node"
            
            case .ReadMessages:
                return "/services/rest/message/get"
            case .GetUnreadMessageCount:
                return "/services/rest/message/unreadCount"
            case .ReadMessageThread:
                return "/services/rest/message/getThread"
            case .MarkMessageThread:
                return "/services/rest/message/markThreadRead"
            case .SendMessage:
                return "/services/rest/message/send"
            case .ReplyMessage:
                return "/services/rest/message/reply"
            }
    }
    
    var method: Alamofire.Method {
        switch self {
            case .Login:
                return .POST
            case .Logout:
                return .POST
            
            case .ReadUser:
                return .GET
            case .SearchByKeyword:
                return .POST
            case .SearchByLocation:
                return .POST
            case .ReadFeedback:
                return .GET
            case CreateFeedback:
                return .POST
                
            case ReadMessages:
                return .POST
            case GetUnreadMessageCount:
                return .POST
            case ReadMessageThread:
                return .POST
            case MarkMessageThread:
                return .POST
            case SendMessage:
                return .POST
            case ReplyMessage:
                return .POST
        }
    }
        
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
            
            // Authentication
            
            case .Login(let username, let password):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                        "username": username,
                        "password": password
                    ]).0
            
            case .Logout(let username, let password):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                    "username": username,
                    "password": password
                    ]).0
            
            // User
            
            case .ReadUser(let userId):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
            
            case .SearchByKeyword(let keyword, let limit, let page):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                    "keyword": keyword,
                    "limit": limit,
                    "page": page
                ]).0
            
            case .SearchByLocation(let minlat, let maxlat,let minlon, let maxlon, let centerlat, let centerlon, let limit):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                        "minlat": minlat,
                        "maxlat": maxlat,
                        "minlon": minlon,
                        "maxlon": maxlon,
                        "centerlat": centerlat,
                        "centerlon": centerlon,
                        "limit": limit
                    ]).0
            
            // Feedback
            
            case .ReadFeedback:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
                
            case .CreateFeedback(let feedback):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                    "node[type]": "trust_referral",
                    "node[field_member_i_trust][0][uid][uid]": feedback.toUser.username,
                    "node[body]": feedback.body,
                    "node[field_guest_or_host][value]": feedback.type,
                    "node[field_rating][value]": feedback.rating,
                    "node[field_hosting_date][0][value][year]": feedback.year,
                    "node[field_hosting_date][0][value][month]": feedback.month
                ]).0
            
            // Message
            
            case .ReadMessages:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
                
            case .GetUnreadMessageCount:
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: nil).0
                
            case .ReadMessageThread(let threadId):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["thread_id": threadId]).0
                
            case .MarkMessageThread(let threadId, let unread):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["thread_id": threadId, "status": unread]).0
            
            case .SendMessage(let message):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                    "recipients": message.participants!.username,
                    "subject": message.subject,
                    "body": message.body
                ]).0
            
            case .ReplyMessage(let message):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["thread_id": message.threadId, "body": message.body]).0
            
            // Default (just in case)
            
            default:
                return mutableURLRequest
        }
    }
}