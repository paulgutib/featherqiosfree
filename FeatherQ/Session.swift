//
//  Session.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/1/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    var deviceToken: String?
    var isLoggedIn = false
    var businessId = 209
    var category: String?
    var timeClose: String?
    var numberLimit: Int?
    var servingTime: String?
    var serviceId: Int?
    var numberStart: Int?
    var key: String?
    var logo: String?
    var address: String?
    var peopleInLine: Int?
    var businessName: String?
    
}
