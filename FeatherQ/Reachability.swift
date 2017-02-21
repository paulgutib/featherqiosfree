//
//  Reachability.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 2/20/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

// SOURCE: http://www.brianjcoleman.com/tutorial-check-for-internet-connection-in-swift/

import Foundation
import SystemConfiguration
import UIKit
import SwiftSpinner

open class Reachability {
    
    static let instance = Reachability()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func checkNetwork() -> Bool {
        let isConnected = Reachability.isConnectedToNetwork()
        if !isConnected {
            SwiftSpinner.show("Make sure the device is connected to the internet.", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
        }
        return isConnected
    }
}
