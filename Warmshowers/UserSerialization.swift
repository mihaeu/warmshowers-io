//
//  UserSerialization.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 23/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import SwiftyJSON

public class UserSerialization
{
    public static func deserializeJSON(json: JSON) -> User
    {
        var user = User(
            uid: json["uid"].intValue,
            name: json["name"].stringValue
        )
        
        user.mode = json["mode"].int
        user.sort = json["sort"].int
        user.threshold = json["threshold"].int
        user.theme = json["theme"].int
        user.signature = json["signature"].int
        user.created = json["created"].int
        user.access = json["access"].int
        user.status = json["status"].int
        user.timezone = json["timezone"].int
        user.language = json["language"].string
        user.picture = json["picture"].string
        user.login = json["login"].int
        user.timezone_name = json["timezone_name"].string
        user.signature_format = json["signature_format"].int
        user.force_password_change = json["force_password_change"].int
        user.fullname = json["fullname"].string
        user.notcurrentlyavailable = json["notcurrentlyavailable"].int
        user.notcurrentlyavailable_reason = json["notcurrentlyavailable_reason"].string
        user.fax_number = json["fax_number"].string
        user.mobilephone = json["mobilephone"].string
        user.workphone = json["workphone"].string
        user.homephone = json["homephone"].string
        user.preferred_notice = json["preferred_notice"].int
        user.cost = json["cost"].string
        user.maxcyclists = json["maxcyclists"].int
        user.storage = json["storage"].int
        user.motel = json["motel"].string
        user.campground = json["campground"].string
        user.bikeshop = json["bikeshop"].string
        user.comments = json["comments"].string
        user.shower = json["shower"].int
        user.kitchenuse = json["kitchenuse"].int
        user.lawnspace = json["lawnspace"].int
        user.sag = json["sag"].int
        user.bed = json["bed"].int
        user.laundry = json["laundry"].int
        user.food = json["food"].int
        user.howdidyouhear = json["howdidyouhear"].string
        user.lastcorrespondence = json["lastcorrespondence"].string
        user.languagesspoken = json["languagesspoken"].string
        user.URL = json["URL"].string
        user.isstale = json["isstale"].int
        user.isstale_date = json["isstale_date"].int
        user.isstale_reason = json["isstale_reason"].string
        user.isunreachable = json["isunreachable"].string
        user.unreachable_date = json["unreachable_date"].string
        user.unreachable_reason = json["unreachable_reason"].string
        user.becomeavailable = json["becomeavailable"].int
        user.set_unavailable_timestamp = json["set_unavailable_timestamp"].int
        user.set_available_timestamp = json["set_available_timestamp"].int
        user.last_unavailability_pester  = json["last_unavailability_pester"].int
        user.hide_donation_status = json["hide_donation_status"].string
        user.email_opt_out = json["email_opt_out"].int
        user.oid = json["oid"].int
        user.type = json["type"].int
        user.street = json["street"].string
        user.additional = json["additional"].string
        user.city = json["city"].string
        user.province = json["province"].string
        user.postal_code = json["postal_code"].int
        user.country = json["country"].string
        user.latitude = json["latitude"].double
        user.longitude = json["longitude"].double
        user.source = json["source"].int
        user.node_notify_mailalert = json["node_notify_mailalert"].int
        user.comment_notify_mailalert = json["comment_notify_mailalert"].int
        
        return user
    }
}
