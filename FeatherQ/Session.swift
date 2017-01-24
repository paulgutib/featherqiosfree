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
    var businessId = "209"
    var viewedBusinessId = "209"
    var category: String?
    var timeClose: String?
    var timeOpen: String?
    var numberLimit: Int?
    var servingTime: String?
    var serviceId: String?
    var numberStart: Int?
    var key: String?
    var logo: String?
    var address: String?
    var peopleInLine: String?
    var businessName: String?
    var broadcastNumbers = [String]()
    var playSound = true
    var transactionNums = [String]()
    var processQueue = [[String:String]]()
    var estimatedSecs: Int?
    var lastCalled: String?
    var selectedCategories = [String]()
    
}
