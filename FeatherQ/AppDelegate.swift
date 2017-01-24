//
//  AppDelegate.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/9/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Locksmith
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Uploadcare

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.8, green: 0.3843, blue: 0, alpha: 1.0) /* #cc6200 */
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UITabBar.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UIButton.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UITableView.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        UINavigationBar.appearance().tintColor = UIColor.white // set a universal tint color for all views depending on app motiff
        UISegmentedControl.appearance().tintColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0)
        
        IQKeyboardManager.sharedManager().enable = true
        UCClient.default().setPublicKey("844c2b9e554c2ee5cc0a")
        
        let onboarded = UserDefaults.standard.bool(forKey: "fqiosappfreeonboard")
        if !onboarded {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startOnboarding")
        }
        else {
            self.selectMyBusinessAsDefault()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == .active {
            let userInfoDict = userInfo as NSDictionary as! [String: AnyObject]
            let msgType = userInfoDict["aps"]!["msg_type"]!! as! String
            if msgType == "issue" {
                Alamofire.request(Router.getAllNumbers(business_id: Session.instance.businessId)).responseJSON { response in
                    if response.result.isFailure {
                        debugPrint(response.result.error!)
//                        let errorMessage = (response.result.error?.localizedDescription)! as String
//                        SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
//                            SwiftSpinner.hide()
//                        })
//                        return
                    }
                    let responseData = JSON(data: response.data!)
                    debugPrint(responseData)
                    if responseData["numbers"] != nil {
                        Session.instance.transactionNums.removeAll()
                        Session.instance.processQueue.removeAll()
                        for numberList in responseData["numbers"]["unprocessed_numbers"] {
                            let dataObj = numberList.1.dictionaryObject!
                            Session.instance.transactionNums.append("\(dataObj["transaction_number"]!)")
                            Session.instance.processQueue.append([
                                "transaction_number": "\(dataObj["transaction_number"]!)",
                                "priority_number": "\(dataObj["priority_number"]!)",
                                "confirmation_code": dataObj["confirmation_code"] as! String,
                                "time_queued": "\(dataObj["time_queued"]!)",
                                "notes": dataObj["note"] as! String,
                                "time_called": "\(dataObj["time_called"]!)",
                            ])
                        }
                    }
                }
            }
            else {
                if msgType == "call" {
                    Session.instance.playSound = true
                    Alamofire.request(Router.getBusinessBroadcast(business_id: Session.instance.viewedBusinessId)).responseJSON { response in
                        if response.result.isFailure {
                            debugPrint(response.result.error!)
                            let errorMessage = (response.result.error?.localizedDescription)! as String
                            SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                                SwiftSpinner.hide()
                            })
                            return
                        }
                        let responseData = JSON(data: response.data!)
                        debugPrint(responseData)
                        if responseData != nil {
                            Session.instance.broadcastNumbers.removeAll()
                            for callNums in responseData["broadcast_data"]["called_numbers"] {
                                let dataObj = callNums.1.dictionaryObject!
                                let pNum = dataObj["priority_number"] as! String
                                Session.instance.broadcastNumbers.append(pNum)
                                Session.instance.peopleInLine = self.peopleInLineChecker(arg0: responseData["broadcast_data"]["people_in_line"].intValue)
                                Session.instance.servingTime = self.convertServingTime(timeArg: responseData["broadcast_data"]["serving_time"].intValue)
                                Session.instance.lastCalled = responseData["broadcast_data"]["last_called"].stringValue
                            }
                        }
                    }
                }
//                else {
//                    Session.instance.playSound = false
//                }
                
            }
            debugPrint(msgType + " received")
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token (string):", deviceTokenString)
        print("Device Token (raw):", deviceToken)
        Session.instance.deviceToken = deviceTokenString

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Session.instance.deviceToken = "F5AF8369B371F5CA8AF1AFAA6062FE3C60223C26EE2FA22066CB4BAAD6B5E1EA"
        debugPrint(Session.instance.deviceToken!)
        print("Failed to register:", error)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return UCClient.default().handle(url)
    }
    
    func selectMyBusinessAsDefault() {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "fqiosappfree")
        if dictionary != nil {
            let tabBarController = self.window?.rootViewController as! UITabBarController
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
            var rootViewControllers = tabBarController.viewControllers
            rootViewControllers?[2] = vc
            vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
            tabBarController.setViewControllers(rootViewControllers, animated: false)
            tabBarController.selectedIndex = 2
        }
    }
    
    func convertServingTime(timeArg: Int) -> String {
        let (h, m) = self.secondsToHoursMinutesSeconds(seconds: timeArg)
        if m < 3 {
            return "less than 3 minutes"
        }
        if h > 0 {
            return "\(h) hours and \(m) minutes"
        }
        return "\(m) minutes"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func peopleInLineChecker(arg0: Int) -> String {
        if arg0 < 5 {
            return "less than 5"
        }
        return "\(arg0)"
    }
}

