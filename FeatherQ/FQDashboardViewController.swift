//
//  FQDashboardViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import Locksmith

class FQDashboardViewController: UIViewController {

    @IBOutlet weak var processQueueBtn: UIButton!
    @IBOutlet weak var issueNumberBtn: UIButton!
    @IBOutlet weak var broadcastBtn: UIButton!
    @IBOutlet weak var issueDefault: UIButton!
    @IBOutlet weak var processDefault: UIButton!
    @IBOutlet weak var broadcastDefault: UIButton!
    
    var issueBool = false
    var processBool = false
    var broadcastBool = false
    
    let checkboxChecked = UIImage(named: "CheckboxChecked")
    let checkBoxEmpty = UIImage(named: "CheckboxEmpty")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.processQueueBtn.layer.cornerRadius = 5.0
        self.processQueueBtn.clipsToBounds = true
        self.issueNumberBtn.layer.cornerRadius = 5.0
        self.issueNumberBtn.clipsToBounds = true
        self.broadcastBtn.layer.cornerRadius = 5.0
        self.broadcastBtn.clipsToBounds = true
        self.autoLoginForRegisteredUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func issueSetDefault(_ sender: UIButton) {
        issueBool = !issueBool
        if issueBool {
            self.issueDefault.setImage(self.checkboxChecked, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        processBool = false
        broadcastBool = false
        self.setDefaultBusinessView(boolVal: issueBool, viewType: "autoIssue")
    }
    
    @IBAction func processSetDefault(_ sender: UIButton) {
        processBool = !processBool
        if processBool {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkboxChecked, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else {
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        issueBool = false
        broadcastBool = false
        self.setDefaultBusinessView(boolVal: processBool, viewType: "autoProcess")
    }
    
    @IBAction func broadcastSetDefault(_ sender: UIButton) {
        broadcastBool = !broadcastBool
        if broadcastBool {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkboxChecked, for: .normal)
        }
        else {
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        processBool = false
        issueBool = false
        self.setDefaultBusinessView(boolVal: broadcastBool, viewType: "autoBroadcast")
    }
    
    
    func setDefaultBusinessView(boolVal: Bool, viewType: String) {
        if boolVal {
            UserDefaults.standard.set(viewType, forKey: "defaultView")
        }
        else {
            UserDefaults.standard.removeObject(forKey: "defaultView")
        }
    }
    
    func autoLoginForRegisteredUser() {
        if !Session.instance.isLoggedIn {
            SwiftSpinner.show("Initializing..")
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "fqiosappfree")
            if dictionary != nil {
                let emailVal = dictionary!["email"] as! String
                let passwordVal = dictionary!["password"] as! String
                let deviceToken = dictionary!["device_token"] as! String
                Alamofire.request(Router.postLogin(email: emailVal, password: passwordVal, deviceToken: deviceToken)).responseJSON { response in
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
                    Session.instance.isLoggedIn = true
//                    Session.instance.businessId = responseData["business_id"].intValue
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
                            Session.instance.numberLimit = dataObj["number_limit"] as? Int
                            Session.instance.servingTime = dataObj["serving_time"] as? String
                            Session.instance.serviceId = dataObj["service_id"] as? Int
                            Session.instance.numberStart = dataObj["number_start"] as? Int
                            Session.instance.key = dataObj["key"] as? String
                            Session.instance.logo = dataObj["logo"] as? String
                            Session.instance.address = dataObj["address"] as? String
                            Session.instance.businessId = dataObj["business_id"] as! Int
                            Session.instance.peopleInLine = dataObj["people_in_line"] as? Int
                            Session.instance.businessName = dataObj["name"] as? String
                        }
                        self.goToDefaultView()
                        SwiftSpinner.hide()
                    }
                }
            }
        }
    }
    
    func goToDefaultView() {
        let defaultView = UserDefaults.standard.value(forKey: "defaultView")
        if defaultView != nil {
            let dv = defaultView as! String
            self.markDefaultBusinessView(dv: dv)
            self.performSegue(withIdentifier: dv, sender: self)
        }
    }
    
    func markDefaultBusinessView(dv: String) {
        if dv == "autoIssue" {
            self.issueDefault.setImage(self.checkboxChecked, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else if dv == "autoProcess" {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkboxChecked, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else if dv == "autoBroadcast" {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkboxChecked, for: .normal)
        }
    }
    
}
