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
