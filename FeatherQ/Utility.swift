//
//  Utility.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import Foundation

class Utility {
    
    static let instance = Utility()
    
    func anyObjectNilChecker(anyObject: Any, placeholder: String) -> String {
        var toString = anyObject as? String
        if toString == nil || (toString?.isEmpty)! || toString == "" {
            toString = placeholder
        }
        return toString!
    }
    
}
