//
//  User.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

class User
{
    var uid: Int
    var name: String
    
    var mode: Int?
    var sort: Int?
    var threshold: Int?
    var theme: Int?
    var signature: Int?
    var created: Int?
    var access: Int?
    var status: Int?
    var timezone: Int?
    var language: String?
    var picture: String?
    var login: Int?
    var timezone_name: String?
    var signature_format: Int?
    var force_password_change: Int?
    var fullname: String?
    var notcurrentlyavailable: Int?
    var notcurrentlyavailable_reason: String?
    var fax_number: String?
    var mobilephone: String?
    var workphone: String?
    var homephone: String?
    var preferred_notice: Int?
    var cost: String?
    var maxcyclists: Int?
    var storage: Int?
    var motel: String?
    var campground: String?
    var bikeshop: String?
    var comments: String?
    var shower: Int?
    var kitchenuse: Int?
    var lawnspace: Int?
    var sag: Int?
    var bed: Int?
    var laundry: Int?
    var food: Int?
    var howdidyouhear: String?
    var lastcorrespondence: String?
    var languagesspoken: String?
    var URL: String?
    var isstale: Int?
    var isstale_date: Int?
    var isstale_reason: String?
    var isunreachable: String?
    var unreachable_date: String?
    var unreachable_reason: String?
    var becomeavailable: Int?
    var set_unavailable_timestamp: Int?
    var set_available_timestamp: Int?
    var last_unavailability_pester :Int?
    var hide_donation_status: String?
    var email_opt_out: Int?
    var oid: Int?
    var type: Int?
    var street: String?
    var additional: String?
    var city: String?
    var province: String?
    var postal_code: Int?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var source: Int?
    var node_notify_mailalert: Int?
    var comment_notify_mailalert: Int?
    
    init(uid: Int, name: String)
    {
        self.uid = uid
        self.name = name
    }
}
