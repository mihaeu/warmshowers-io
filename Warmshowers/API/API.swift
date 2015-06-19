//
//  API.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 09/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import Alamofire
import SwiftyJSON
import BrightFutures

/// Warmshowers.org API
public class API
{
    /// Alamofire serves a singleton, but we want to be able to mock this
    var manager: Manager
    
    static let sharedInstance = API()

    public var loggedInUser: User?
    public var csrfToken: String?
    
    struct Status {
        static let AlreadyLoggedIn = 406
        static let LoginOk = 200
    }
    
    /**
        :param: manager Alamofire Manager
    */
    public init(manager: Manager = Alamofire.Manager.sharedInstance)
    {
        self.manager = manager
    }
    
    // MARK: Authentication API Methods
    
    /**
        Login a user.
    
        The login is cookie based. Alamofire is handling this in the background and there
        is nothing left to do on further requests. Trying to login while already logged in
        will produce an error and will *NOT* return the user object again. Because of this
        it is critical that the user object of the currently logged in user is safed on
        the first login.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-login
    
        :param: username
        :param: password
    
        :returns: Future<User>
    */
    public func login(username: String, password: String) -> Future<User>
    {
        let promise = Promise<User>()
        
        manager.request(Router.Login(username: username, password: password))
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    if response?.statusCode == Status.LoginOk {
                        log.info("\(username) logged in with status \(response?.statusCode)")
                        var json = JSON(json!)
                        
                        let user = UserSerialization.deserializeJSON(json["user"])
                        user.password = password
                        self.loggedInUser = user
                        
                        self.csrfToken = "12345"
                        promise.success(user)
//                        Not yet supported by stable API Server
//
//                        self.requestCsrfToken()
//                            .onSuccess() { token in
//                                self.csrfToken = token
//                                promise.success(user)
//                            }
//                            .onFailure() { error in
//                                promise.failure(NSError(domain: "Couldn't request CSRF token.", code: Status.LoginOk, userInfo: nil))
//                            }
                        
                        
                    } else if response?.statusCode == Status.AlreadyLoggedIn {
                        log.info("\(username) already logged in with status \(response?.statusCode)")
                        promise.failure(NSError(domain: "User already logged in", code: Status.AlreadyLoggedIn, userInfo: nil))
                    } else {
                        log.info("\(username) bad credentials with status \(response?.statusCode)")
                        promise.failure(NSError(domain: "Bas user credentials in", code: Status.AlreadyLoggedIn, userInfo: nil))
                    }
                }
        }
        
        return promise.future
    }
    
    /**
        Logout a user.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-logout
    
        :param: username
        :param: password
        
        :returns: Future<Bool>
    */
    public func logout(username: String, password: String) -> Future<Bool>
    {
        let promise = Promise<Bool>()

        manager.request(Router.Logout(username: username, password: password, token: csrfToken!))
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    log.info("Logged out \(username) with status \(response?.statusCode)")
                    promise.success(true)
                }
        }
        
        return promise.future
    }
    
    /**
     * Request a CSRF Token that has to be used on every request after the login (even logout).
     * Has to be called immidiately after login, before any other request.
     *
     * https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#csrf
     *
     * :returns: Future<String>
     */
    public func requestCsrfToken() -> Future<String>
    {
        let promise = Promise<String>()
        
        manager.request(Router.RequestCsrfToken())
            .responseString { (request, response, token, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    log.info("Got CSRF Token: \(token)")
                    promise.success(token!)
                }
        }
        return promise.future
    }
    
    // MARK: Search API Methods
    
    /**
        Get a single user by Id.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-userretrieve
        
        :param: userId
        
        :return: Future<User>
    */
    public func getUser(userId: Int) -> Future<User>
    {
        let promise = Promise<User>()
        
        manager.request(Router.ReadUser(userId: userId, token: csrfToken!))
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    log.info("Got user by id \(response?.statusCode)")
                    var json = JSON(json!)
                    promise.success(UserSerialization.deserializeJSON(json))
                }
        }
        
        return promise.future
    }
    
    /**
        Search for other user by keyword.
    
        The keyword can either be the username or email of a user or the name of a location.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-bykeyword
    
        :param: keyword
        :param: limit Default: 4
        :param: page Default: 0
    
        :returns: Future<[Int:User]>
    */
    public func searchByKeyword(keyword: String, limit: Int = 4, page: Int = 0) -> Future<[Int:User]>
    {
        let promise = Promise<[Int:User]>()
        
        manager.request(Router.SearchByKeyword(keyword: keyword, limit: limit, page: page, token: csrfToken!))
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    log.info("Got hosts by keyword \(response?.statusCode)")
                    var json = JSON(json!)
                    var users = [Int:User]()
                    for (key: String, userJson: JSON) in json["accounts"] {
                        let uid = key.toInt()
                        let user = UserSerialization.deserializeJSON(userJson)
                        users[uid!] = user                      
                    }
                    promise.success(users)
                }
        }
        
        return promise.future
    }
    
    /**
        Search for users by location.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-bylocation
        
        :params: minlat 
        :params: maxlat
        :params: minlon
        :params: maxlon
        :params: centerlat
        :params: centerlon
        :params: limit
    
        :returns: Future<[Int:User]>
    */
    public func searchByLocation(minlat: Double, maxlat: Double, minlon: Double, maxlon: Double, centerlat: Double, centerlon: Double, limit: Int = 100) -> Future<[Int:User]>
    {
        let promise = Promise<[Int:User]>()
        
        manager.request(Router.SearchByLocation(minlat: minlat, maxlat: maxlat, minlon: minlon, maxlon: maxlon, centerlat: centerlat, centerlon: centerlon, limit: limit, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    let accounts = json["accounts"]
                    log.info("Search by location (\(minlat),\(minlon) to \(maxlat),\(maxlon)) and found \(accounts.count) [Status: \(response?.statusCode)]")
                    
                    var users = [Int:User]()
                    for (key: String, userJson: JSON) in accounts {
                        let user = UserSerialization.deserializeJSON(userJson)
                        users[user.uid] = user
                    }
                    println(users.count)
                    promise.success(users)
                }
        }
        return promise.future
    }

    // MARK: Feedback API Methods
    
    /**
        Get all the feedback of a user.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-json_recommendations
    
        :param: userId User ID
    
        :returns: Future<[Feedback]>
    */
    func getFeedbackForUser(userId: Int) -> Future<[Feedback]>
    {
        let promise = Promise<[Feedback]>()
        
        manager
            .request(Router.ReadFeedback(userId: userId, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    var feedback = [Feedback]()
                    for (key, feedbackJson) in json["recommendations"] {
                        feedback.append(FeedbackSerialization.deserializeJSON(feedbackJson["recommendation"]))
                    }
                    promise.success(feedback)
                }
            }
        
        return promise.future
    }
    
    /**
        Create new feedback for a user.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-create_feedback
    
        :param: Feedback
    
        :returns: Future<Bool>
    */
    func createFeedbackForUser(feedback: Feedback) -> Future<Bool>
    {
        let promise = Promise<Bool>()
        
        manager
            .request(Router.CreateFeedback(feedback: feedback, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    promise.success(true)
                }
        }
        
        return promise.future
    }

    // MARK: Message API Methods
    
    /**
        Sends a private message to another user.
    
        Sending a message starts a new message thread (imagine GMail Conversations) and cannot be used for
        answering messages. Use the `replyMessage` for this purpose.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-message_send
    
        :param: recipients
        :param: subject
        :param: body
    
        :returns: Future<Bool>
    */
    public func sendMessage(recipients: [User], subject: String, body: String) -> Future<Bool>
    {
        let promise = Promise<Bool>()
        
        manager
            .request(Router.SendMessage(recipients: recipients, subject: subject, body: body, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    promise.success(true)
                }
        }
        
        return promise.future
    }
    
    /**
        Reply to a message in a message thread.
    
        This is like sending a message, but for message threads that have already been created. Do not
        mix this and `sendMessage`.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-privatemsg_reply
    
        :param: threadId
        :param: body
    
        :returns: Future<Bool>
    */
    public func replyMessage(threadId: Int, body: String) -> Future<Bool>
    {
        let promise =  Promise<Bool>()
        
        manager
            .request(Router.ReplyMessage(threadId: threadId, body: body, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    promise.success(true)
                }
        }
        
        return promise.future
    }
    
    /**
        Get the number of unread messages.
    
        This is quicker than getting all the messages and checking which are unread. Use when checking for new messages.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-message_unread
    
        :returns: Future<Int>
    */
    public func getUnreadMessagesCount() -> Future<Int>
    {
        let promise = Promise<Int>()
        
        manager
            .request(Router.GetUnreadMessageCount(token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    promise.success(json.intValue)
                }
        }

        return promise.future
    }
    
    /**
        Get all messages.
    
        This will return all message threads, but not the full thread itself.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-message_get_all
    
        :returns: Future<Message>
    */
    public func getAllMessages() -> Future<[Message]>
    {
        let promise = Promise<[Message]>()
        
        manager
            .request(Router.ReadMessages(token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    var messages = [Message]()
                    for (key, messageJson) in json {
                        messages.append(MessageSerialization.deserializeJSON(messageJson))
                    }
                    promise.success(messages)
                }
        }
        
        return promise.future
    }

    /**
        Get all full messages in a message thread.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-message_get_thread
    
        :param: threadId
    */
    public func readMessageThread(threadId: Int) -> Future<MessageThread>
    {
        let promise = Promise<MessageThread>()
        
        manager
            .request(Router.ReadMessageThread(threadId: threadId, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    var messageThread = MessageThreadSerialization.deserializeJSON(json)
                    promise.success(messageThread)
                }
            }
        
        return promise.future
    }
    
    /**
        Mark message threads as read or unread.
    
        https://github.com/warmshowers/Warmshowers.org/wiki/Warmshowers-RESTful-Services-for-Mobile-Apps#wiki-markThreadRead
    
        :param: threadId
        :param: unread True if the message thread should be marked as unread or false if it should be marked read.
    
        :returns: Future<Bool>
    */
    public func markMessageThreadStatus(threadId: Int, unread: Bool) -> Future<Bool>
    {
        let promise = Promise<Bool>()
        
        manager
            .request(Router.MarkMessageThread(threadId: threadId, unread: unread, token: csrfToken!))
            .responseJSON() { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    var json = JSON(json!)
                    promise.success(json.boolValue)
                }
        }
        
        return promise.future
        
    }
}
