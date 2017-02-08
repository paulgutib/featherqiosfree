//
//  FQLoginViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Locksmith

class FQLoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loginBtn.layer.cornerRadius = 5.0
        self.loginBtn.clipsToBounds = true
        self.email.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.password.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FQOnboardingPushNotificationViewController") as! FQOnboardingPushNotificationViewController
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: false, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func emailTxt(_ sender: UITextField) {
        self.password.becomeFirstResponder()
    }
    
    @IBAction func passwordTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
//    @IBAction func signUpReset(_ sender: UIButton) {
//        self.navigationController!.popToRootViewController(animated: true)
//    }
    
    @IBAction func loginAccount(_ sender: UIButton) {
        if self.emailPasswordValidity() {
            SwiftSpinner.show("Logging in..")
            Alamofire.request(Router.postLogin(email: self.email.text!, password: self.password.text!, deviceToken: Session.instance.deviceToken)).responseJSON { response in
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
                let access_token = responseData["access_token"].stringValue
                if responseData != nil && !access_token.isEmpty {
                    //store tokens
                    do {
                        try Locksmith.updateData(data: [
                            "access_token": access_token,
                            "email": self.email.text!,
                            "password": self.password.text!,
                            "device_token": Session.instance.deviceToken
                        ], forUserAccount: "fqiosappfree")
                        Session.instance.isLoggedIn = true
                        Session.instance.businessId = "\(responseData["business_id"])"
                        Session.instance.serviceId = "\(responseData["service_id"])"
                        Alamofire.request(Router.getBusiness(business_id: Session.instance.businessId)).responseJSON { response in
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
                            for business in responseData {
                                let dataObj = business.1.dictionaryObject!
                                Session.instance.category = dataObj["category"] as? String
                                Session.instance.timeClose = dataObj["time_close"] as? String
                                Session.instance.timeOpen = dataObj["time_open"] as? String
                                Session.instance.numberLimit = dataObj["number_limit"] as? Int
                                Session.instance.servingTime = dataObj["serving_time"] as? String
                                Session.instance.numberStart = dataObj["number_start"] as? Int
                                Session.instance.key = dataObj["key"] as? String
                                Session.instance.logo = Utility.instance.anyObjectNilChecker(dataObj["logo"]!, placeholder: "")
                                Session.instance.address = dataObj["address"] as? String
                                Session.instance.peopleInLine = "\(dataObj["people_in_line"]!)"
                                Session.instance.businessName = dataObj["name"] as? String
                            }
                            let preferences = UserDefaults.standard
                            preferences.set(true, forKey: "fqiosappfreeloggedin")
                            preferences.synchronize()
                            let startMainApp = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "startMainApp") as! UITabBarController
                            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
                            var rootViewControllers = startMainApp.viewControllers
                            rootViewControllers?[2] = vc
                            vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
                            startMainApp.setViewControllers(rootViewControllers, animated: false)
                            startMainApp.selectedIndex = 2
                            UIApplication.shared.keyWindow?.rootViewController = startMainApp
//                            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
//                            var rootViewControllers = self.tabBarController?.viewControllers
//                            rootViewControllers?[2] = vc
//                            vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
//                            self.tabBarController?.setViewControllers(rootViewControllers, animated: false)
                            
                            SwiftSpinner.hide()
                        }
                    }catch {
                        debugPrint(error)
                    }
                }
                else {
                    let alertBox = UIAlertController(title: "Account Doesn't Exist", message: "The credentials you entered doesn't match any accounts. Please try again.", preferredStyle: .alert)
                    alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertBox, animated: true, completion: nil)
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    func emailPasswordValidity() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: self.email.text!) {
            let alertBox = UIAlertController(title: "Invalid Email", message: "Email address must have the correct email format.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.password.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Password", message: "Passwords must not be empty.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
