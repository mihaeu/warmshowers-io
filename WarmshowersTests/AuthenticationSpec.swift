//
//  AuthenticationSpec.swift
//  Warmshowers
//
//  Created by admin on 07/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import Quick
import Nimble
import Warmshowers

class AuthenticationSpec: QuickSpec
{
    override func spec() {
        var authentication = Authentication()
        
        beforeEach() {
            authentication = Authentication()
        }
        
        it("logs in mock user") {
            expect(authentication.login("test", password: "pass")).to(beTruthy())
        }
        
        it("does not log in invalid user") {
            expect(authentication.login("wrong", password: "wrong")).to(beFalsy())
        }
    }
}
