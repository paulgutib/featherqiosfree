//
//  FQBusiness.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import Foundation

class FQBusiness {
    
    var address: String?
    var business_id: String?
    var category: String?
    var logo: String?
    var key: String?
    var people_in_line: String?
    var time_close: String?
    var name: String?
    var serving_time: String?
    
    init(modelAttr: [String: Any]) {
        self.address = modelAttr["address"] as? String
        self.business_id = "\(modelAttr["business_id"]!)"
        self.category = modelAttr["category"] as? String
        self.logo = Utility.instance.anyObjectNilChecker(anyObject: modelAttr["logo"]!, placeholder: "")
        self.key = modelAttr["key"] as? String
        self.people_in_line = self.peopleInLineChecker(arg0: modelAttr["people_in_line"]!)
        self.time_close = modelAttr["time_close"] as? String
        self.name = modelAttr["name"] as? String
        self.serving_time = Utility.instance.anyObjectNilChecker(anyObject: modelAttr["serving_time"]!, placeholder: "less than 1 minute")
    }
    
    func peopleInLineChecker(arg0: Any) -> String {
        let argVal = arg0 as? Int
        if argVal! < 5 {
            return "less than 5"
        }
        return "\(argVal!)"
    }
    
}
