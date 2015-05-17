//
//  TestViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 14/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class TestViewController: UIViewController
{
    var api = API()
    
    @IBAction func correctLogin(sender: AnyObject)
    {
        api.login(APISecrets.username, password: APISecrets.password)
            .onSuccess() { user in
            log.info(user.name)
        }
    }
    
    @IBAction func incorrectLogin(sender: AnyObject)
    {
        api.login("bad", password: "test")
    }

    @IBAction func logout(sender: AnyObject)
    {
        api.logout(APISecrets.username, password: APISecrets.password)
    }
    
    @IBAction func searchByKeyword(sender: AnyObject)
    {
        api.hostsByKeyword("palisade").onSuccess() { users in
            for (uid, user) in users {
                println("found: \(uid) \(user.name)")
            }
        }
    }
    
    @IBAction func searchById()
    {
        api.getUser(1165).onSuccess() { user in
            println("got \(user.name)")
        }
    }
}
