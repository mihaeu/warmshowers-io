//
//  API.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 09/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import Alamofire
import SwiftyJSON

internal class API
{
    var manager: Manager
    var notificationCenter: NSNotificationCenter
    
    internal let BaseURL = "https://www.warmshowers.org"
    internal let LoginURL = "/services/rest/user/login"
    
    internal var sessid: String?
    internal var session_name: String?
    
    internal init(
        manager: Manager = Alamofire.Manager.sharedInstance,
        notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter())
    {
        self.manager = manager
        self.notificationCenter = notificationCenter
    }
    
    internal func login(username: String, password: String)
    {
        Alamofire.request(.POST, BaseURL + LoginURL, parameters: ["username": username, "password": password])
//            .validate(statusCode: 200..<300)
            .responseJSON { (request, response, json, error) in
                if error != nil {
                    // log etc.
                    log.error(error?.description)
                } else {
                    var json = JSON(json!)
                    
                    self.sessid = json["sessid"].stringValue
                    self.session_name = json["session_name"].stringValue
                    
                    let user = self.deserializeUserJson(json)
                    log.info(user.name)
                    self.notificationCenter.postNotificationName(
                        Notifications.LoginName,
                        object: nil,
                        userInfo: [Notifications.LoginDataKey: user]
                    )
                }
        }
    }
    
    internal func deserializeUserJson(json: JSON) -> User
    {
        var user = User(
            uid: json["user"]["uid"].intValue,
            name: json["user"]["name"].stringValue
        )
        
        user.mode = json["user"]["mode"].intValue
        user.sort = json["user"]["sort"].intValue
        user.threshold = json["user"]["threshold"].intValue
        user.theme = json["user"]["theme"].intValue
        user.signature = json["user"]["signature"].intValue
        user.created = json["user"]["created"].intValue
        user.access = json["user"]["access"].intValue
        user.status = json["user"]["status"].intValue
        user.timezone = json["user"]["timezone"].intValue
        user.language = json["user"]["language"].stringValue
        user.picture = json["user"]["picture"].stringValue
        user.login = json["user"]["login"].intValue
        user.timezone_name = json["user"]["timezone_name"].stringValue
        user.signature_format = json["user"]["signature_format"].intValue
        user.force_password_change = json["user"]["force_password_change"].intValue
        user.fullname = json["user"]["fullname"].stringValue
        user.notcurrentlyavailable = json["user"]["notcurrentlyavailable"].intValue
        user.notcurrentlyavailable_reason = json["user"]["notcurrentlyavailable_reason"].stringValue
        user.fax_number = json["user"]["fax_number"].stringValue
        user.mobilephone = json["user"]["mobilephone"].stringValue
        user.workphone = json["user"]["workphone"].stringValue
        user.homephone = json["user"]["homephone"].stringValue
        user.preferred_notice = json["user"]["preferred_notice"].intValue
        user.cost = json["user"]["cost"].stringValue
        user.maxcyclists = json["user"]["maxcyclists"].intValue
        user.storage = json["user"]["storage"].intValue
        user.motel = json["user"]["motel"].stringValue
        user.campground = json["user"]["campground"].stringValue
        user.bikeshop = json["user"]["bikeshop"].stringValue
        user.comments = json["user"]["comments"].stringValue
        user.shower = json["user"]["shower"].intValue
        user.kitchenuse = json["user"]["kitchenuse"].intValue
        user.lawnspace = json["user"]["lawnspace"].intValue
        user.sag = json["user"]["sag"].intValue
        user.bed = json["user"]["bed"].intValue
        user.laundry = json["user"]["laundry"].intValue
        user.food = json["user"]["food"].intValue
        user.howdidyouhear = json["user"]["howdidyouhear"].stringValue
        user.lastcorrespondence = json["user"]["lastcorrespondence"].stringValue
        user.languagesspoken = json["user"]["languagesspoken"].stringValue
        user.URL = json["user"]["URL"].stringValue
        user.isstale = json["user"]["isstale"].intValue
        user.isstale_date = json["user"]["isstale_date"].intValue
        user.isstale_reason = json["user"]["isstale_reason"].stringValue
        user.isunreachable = json["user"]["isunreachable"].stringValue
        user.unreachable_date = json["user"]["unreachable_date"].stringValue
        user.unreachable_reason = json["user"]["unreachable_reason"].stringValue
        user.becomeavailable = json["user"]["becomeavailable"].intValue
        user.set_unavailable_timestamp = json["user"]["set_unavailable_timestamp"].intValue
        user.set_available_timestamp = json["user"]["set_available_timestamp"].intValue
        user.last_unavailability_pester  = json["user"]["last_unavailability_pester"].intValue
        user.hide_donation_status = json["user"]["hide_donation_status"].stringValue
        user.email_opt_out = json["user"]["email_opt_out"].intValue
        user.oid = json["user"]["oid"].intValue
        user.type = json["user"]["type"].intValue
        user.street = json["user"]["street"].stringValue
        user.additional = json["user"]["additional"].stringValue
        user.city = json["user"]["city"].stringValue
        user.province = json["user"]["province"].stringValue
        user.postal_code = json["user"]["postal_code"].intValue
        user.country = json["user"]["country"].stringValue
        user.latitude = json["user"]["latitude"].doubleValue
        user.longitude = json["user"]["longitude"].doubleValue
        user.source = json["user"]["source"].intValue
        user.node_notify_mailalert = json["user"]["node_notify_mailalert"].intValue
        user.comment_notify_mailalert = json["user"]["comment_notify_mailalert"].intValue
        
        return user
    }
}

struct Notifications
{
    static let LoginName = "login"
    static let LoginDataKey = "user"
}
