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
    
    var path: String {
        switch self {
            case .Login:
                return "/services/rest/user/login"
        }
    }
        
    var method: Alamofire.Method {
        switch self {
            case .Login:
                return .POST
        }
    }
        
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
            case .Login(let username, let password):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: [
                        "username": username,
                        "password": password
                    ]).0
            default:
                return mutableURLRequest
        }
    }
}