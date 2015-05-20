//
//  APITest.swift
//  Warmshowers
//
//  Created by admin on 20/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import Warmshowers
import XCTest
import BrightFutures

class APITest: XCTestCase
{
    var api: API!
    
    override func setUp()
    {
        api = API()
    }
    
    func testLogsInAndLogsOutUserWithCorrectCredentials()
    {
        api
            .login(APISecrets.Username, password: APISecrets.Password)
            .onSuccess() { user in
                XCTAssertEqual(APISecrets.Username, user.name)
                
                self.api
                    .logout(APISecrets.Username, password: APISecrets.Password)
                    .onSuccess() { status in
                        XCTAssertTrue(status)
                    }
            }
            .onFailure() { error in
                XCTFail(error.description)
            }
    }
    
    func testFailsToLogInUserWithIncorrectCredentials()
    {
        api
            .login("baduser", password: "badpassword!")
            .onSuccess() { user in
                XCTFail("Incorrect credentails accepted!!!!")
            }
            .onFailure() { error in
                XCTAssertTrue(true)
            }
    }
}
