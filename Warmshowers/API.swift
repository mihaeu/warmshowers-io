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
    
    public let BaseURL = "https://www.warmshowers.org"
    public let LoginURL = "/services/rest/user/login"
    public let LogoutURL = "/services/rest/user/logout"
    public let GetPrivateMessagesURL = "/services/rest/message/get"
    public let HostsByKeyword = "/services/rest/hosts/by_keyword"
    public let GetUser = "/services/rest/user/"
    
    public var sessid: String?
    public var session_name: String?
    
    public var username: String?
    public var password: String?
    
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
    
    /**
        Login a user.
    
        The login is cookie based. Alamofire is handling this in the background and there
        is nothing left to do on further requests. Trying to login while already logged in
        will produce an error and will *NOT* return the user object again. Because of this
        it is critical that the user object of the currently logged in user is safed on
        the first login.
    
        :param: username String
        :param: password String
    
        :returns: Future<User>
    */
    public func login(username: String, password: String) -> Future<User>
    {
        let promise = Promise<User>()
        
        Alamofire.request(.POST, BaseURL + LoginURL, parameters: ["username": username, "password": password])
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    if response?.statusCode == Status.LoginOk {
                        log.info("\(username) logged in with status \(response?.statusCode)")
                        var json = JSON(json!)
                        
                        self.sessid = json["sessid"].stringValue
                        self.session_name = json["session_name"].stringValue
                        
                        let user = self.deserializeUserJson(json["user"])
                        self.username = username
                        self.password = password
                        
                        promise.success(user)
                    } else if response?.statusCode == Status.AlreadyLoggedIn {
                        log.info("\(username) already logged in with status \(response?.statusCode)")
                        promise.failure(NSError(domain: "User already logged in", code: Status.AlreadyLoggedIn, userInfo: nil))
                    } else {
                        log.info("\(username) bad credentials with status \(response?.statusCode)")
                        promise.failure(NSError(domain: "User already logged in", code: Status.AlreadyLoggedIn, userInfo: nil))
                    }
                }
        }
        
        return promise.future
    }
    
    /**
        Logout a user.
    
        :param: username String
        :param: password String
        
        :returns: Future<Bool>
    */
    public func logout(username: String, password: String) -> Future<Bool>
    {
        let promise = Promise<Bool>()
        
        Alamofire.request(.POST, BaseURL + LogoutURL, parameters: ["username": username, "password": password])
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
        Search for other user by keyword.
    
        The keyword can either be the username or email of a user or the name of a location.
    
        :param: keyword     String
        :param: limit       Int     Default: 4
        :param: page        Int     Default: 0
    
        :returns: Future<[Int:User]>
    */
    public func hostsByKeyword(keyword: String, limit: Int = 4, page: Int = 0) -> Future<[Int:User]>
    {
        let promise = Promise<[Int:User]>()
        
        Alamofire.request(.POST, BaseURL + HostsByKeyword, parameters: ["keyword": keyword, "limit": limit, "page": page])
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
                        let user = self.deserializeUserJson(userJson)
                        users[uid!] = user                      
                    }
                    promise.success(users)
                }
        }
        
        return promise.future
    }
    
    /**
        Get a single user by Id.
    
        :param: userId Int
    
        :return: Future<User>
    */
    public func getUser(userId: Int) -> Future<User>
    {
        let promise = Promise<User>()
        
        Alamofire.request(.GET, "\(BaseURL)\(GetUser)\(userId)", parameters: nil)
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    log.error(error?.description)
                    promise.failure(error!)
                } else {
                    log.info("Got user by id \(response?.statusCode)")
                    var json = JSON(json!)
                    promise.success(self.deserializeUserJson(json))
                }
        }
        
        return promise.future
    }
    
    
    /**
        Deserializes the JSON user into a User object.
    
        // TODO: this should probably be an optional in case the JSON is messed up
    
        :param: json JSON Swifty JSON data from the Alamofire request.
    
        :returns: User
    */
    public func deserializeUserJson(json: JSON) -> User
    {
        var user = User(
            uid: json["uid"].intValue,
            name: json["name"].stringValue
        )
        
        user.mode = json["mode"].intValue
        user.sort = json["sort"].intValue
        user.threshold = json["threshold"].intValue
        user.theme = json["theme"].intValue
        user.signature = json["signature"].intValue
        user.created = json["created"].intValue
        user.access = json["access"].intValue
        user.status = json["status"].intValue
        user.timezone = json["timezone"].intValue
        user.language = json["language"].stringValue
        user.picture = json["picture"].stringValue
        user.login = json["login"].intValue
        user.timezone_name = json["timezone_name"].stringValue
        user.signature_format = json["signature_format"].intValue
        user.force_password_change = json["force_password_change"].intValue
        user.fullname = json["fullname"].stringValue
        user.notcurrentlyavailable = json["notcurrentlyavailable"].intValue
        user.notcurrentlyavailable_reason = json["notcurrentlyavailable_reason"].stringValue
        user.fax_number = json["fax_number"].stringValue
        user.mobilephone = json["mobilephone"].stringValue
        user.workphone = json["workphone"].stringValue
        user.homephone = json["homephone"].stringValue
        user.preferred_notice = json["preferred_notice"].intValue
        user.cost = json["cost"].stringValue
        user.maxcyclists = json["maxcyclists"].intValue
        user.storage = json["storage"].intValue
        user.motel = json["motel"].stringValue
        user.campground = json["campground"].stringValue
        user.bikeshop = json["bikeshop"].stringValue
        user.comments = json["comments"].stringValue
        user.shower = json["shower"].intValue
        user.kitchenuse = json["kitchenuse"].intValue
        user.lawnspace = json["lawnspace"].intValue
        user.sag = json["sag"].intValue
        user.bed = json["bed"].intValue
        user.laundry = json["laundry"].intValue
        user.food = json["food"].intValue
        user.howdidyouhear = json["howdidyouhear"].stringValue
        user.lastcorrespondence = json["lastcorrespondence"].stringValue
        user.languagesspoken = json["languagesspoken"].stringValue
        user.URL = json["URL"].stringValue
        user.isstale = json["isstale"].intValue
        user.isstale_date = json["isstale_date"].intValue
        user.isstale_reason = json["isstale_reason"].stringValue
        user.isunreachable = json["isunreachable"].stringValue
        user.unreachable_date = json["unreachable_date"].stringValue
        user.unreachable_reason = json["unreachable_reason"].stringValue
        user.becomeavailable = json["becomeavailable"].intValue
        user.set_unavailable_timestamp = json["set_unavailable_timestamp"].intValue
        user.set_available_timestamp = json["set_available_timestamp"].intValue
        user.last_unavailability_pester  = json["last_unavailability_pester"].intValue
        user.hide_donation_status = json["hide_donation_status"].stringValue
        user.email_opt_out = json["email_opt_out"].intValue
        user.oid = json["oid"].intValue
        user.type = json["type"].intValue
        user.street = json["street"].stringValue
        user.additional = json["additional"].stringValue
        user.city = json["city"].stringValue
        user.province = json["province"].stringValue
        user.postal_code = json["postal_code"].intValue
        user.country = json["country"].stringValue
        user.latitude = json["latitude"].doubleValue
        user.longitude = json["longitude"].doubleValue
        user.source = json["source"].intValue
        user.node_notify_mailalert = json["node_notify_mailalert"].intValue
        user.comment_notify_mailalert = json["comment_notify_mailalert"].intValue
        
        return user
    }
}
