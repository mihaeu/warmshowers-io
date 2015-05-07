//
//  Authentication.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 07/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

public class Authentication
{
    struct Mock {
        static var Username = "test"
        static var Password = "pass"
    }
    
    public init()
    {
        // ...
    }
    
    public func login(username: String, password: String) -> Bool
    {
        return username == Mock.Username && password == Mock.Password ? true : false
    }
}
