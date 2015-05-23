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
        api.login(APISecrets.Username, password: APISecrets.Password)
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
        api.logout(APISecrets.Username, password: APISecrets.Password)
    }
    
    @IBAction func searchByKeyword(sender: AnyObject)
    {
        api.searchByKeyword("palisade").onSuccess() { users in
            for (uid, user) in users {
                println("found: \(uid) \(user.name)")
            }
        }
    }
    
    @IBAction func searchById()
    {
        api.getUser(39681).onSuccess() { user in
            println("got \(user.name)")
        }
    }
    
    @IBAction func byLocation()
    {
        api.searchByLocation(30, maxlat: 40, minlon: -100, maxlon: -90, centerlat: 35, centerlon: -95, limit: 50).onSuccess() { users in
            for (uid, user) in users {
                println("found: \(uid) \(user.name)")
            }
        }
    }
    
    @IBAction func getFeedback(sender: AnyObject)
    {
        api.getFeedbackForUser(39681).onSuccess() { feedback in
            for singleFeedback in feedback {
                println("got \(singleFeedback.userForFeedback)")
                println("\(singleFeedback.body)")
            }
        }

    }
    
    @IBAction func createFeedback()
    {
        let feedback = Feedback(
            userIdForFeedback: 39681,
            userForFeedback: "rfay-testuser3-es",
            body: "Test feedback please ignore. Thx. - Michael",
            year: 2015,
            month: 5,
            rating: Feedback.RatingPositive,
            type: Feedback.TypeOther
        )
        api.createFeedbackForUser(feedback).onSuccess() { success in
            println("Created feedback \(success)")
        }.onFailure() { error in
            println(error)
        }
    }
    
    @IBAction func getAllMessages()
    {
        api.getAllMessages().onSuccess() { messages in
            for message in messages {
                println(message.subject)
            }
        }
    }
    
    @IBAction func count()
    {
        api.getUnreadMessagesCount().onSuccess() { count in
            println(count)
        }
    }
}
