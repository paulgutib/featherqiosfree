//
//  Session.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/1/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import Foundation
import UIKit

class Session {
    
    static let instance = Session()
    
    var deviceToken = ""
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
    var transactionNums = [String]()
    var processQueue = [[String:String]]()
    var estimatedSecs: Int?
    var lastCalled: String?
    var selectedCategories = [String]()
    var selectedCategoriesIndexes = [Int]()
    var punchType = "Play"
    var latitudeLoc = "0.0000000"
    var longitudeLoc = "0.0000000"
    var currentTheme: UIColor?
    
    var step1 = false
    var step2 = false
    var step3 = false
    var step4 = false
    var step5 = false
    var step6 = false
    var step7 = false
    var step8 = false
    
    init() {
        let colorTheme = UserDefaults.standard.array(forKey: "fqiosappfreetheme")
        if colorTheme != nil {
            let cgFloats = colorTheme as! [CGFloat]
            self.currentTheme = UIColor(red: cgFloats[0], green: cgFloats[1], blue: cgFloats[2], alpha: 1.0)
        }
        else {
            self.currentTheme = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        }
    }
    
}
