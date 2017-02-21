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
    
    @IBOutlet weak var dboardLayer1: UIView!
    @IBOutlet weak var dboardLayer2: UIView!
    @IBOutlet weak var dboardLayer3: UIView!
    @IBOutlet weak var issueLayer: UIView!
    @IBOutlet weak var processLayer: UIView!
    @IBOutlet weak var broadcastLayer: UIView!
    @IBOutlet weak var step1: UIView!
    @IBOutlet weak var step6: UIView!
    @IBOutlet weak var step8: UIView!
    
    var issueBool = false
    var processBool = false
    var broadcastBool = false
    
    let checkboxChecked = UIImage(named: "CheckboxChecked")
    let checkBoxEmpty = UIImage(named: "CheckboxEmpty")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.processQueueBtn.layer.cornerRadius = 10.0
        self.processQueueBtn.clipsToBounds = true
        self.issueNumberBtn.layer.cornerRadius = 10.0
        self.issueNumberBtn.clipsToBounds = true
        self.broadcastBtn.layer.cornerRadius = 10.0
        self.broadcastBtn.clipsToBounds = true
        self.step1.layer.cornerRadius = 10.0
        self.step1.clipsToBounds = true
        self.step1.layer.borderColor = UIColor.black.cgColor
        self.step1.layer.borderWidth = 2.0
        self.step6.layer.cornerRadius = 10.0
        self.step6.clipsToBounds = true
        self.step6.layer.borderColor = UIColor.black.cgColor
        self.step6.layer.borderWidth = 2.0
        self.step8.layer.cornerRadius = 10.0
        self.step8.clipsToBounds = true
        self.step8.layer.borderColor = UIColor.black.cgColor
        self.step8.layer.borderWidth = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.autoLoginForRegisteredUser()
        if !UserDefaults.standard.bool(forKey: "fqiosappfreeonboardbusiness") {
//            let onboardingBottomLayer = UIView(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.height-54.0, width: UIScreen.main.bounds.width, height: 54.0))
//            onboardingBottomLayer.tag = 4444
//            onboardingBottomLayer.backgroundColor = UIColor.blue
//            UIApplication.shared.keyWindow?.addSubview(onboardingBottomLayer)
            self.dboardLayer1.isHidden = false
            self.dboardLayer2.isHidden = false
            self.dboardLayer3.isHidden = false
            if !Session.instance.step4 {
                self.issueLayer.isHidden = true
                self.processLayer.isHidden = false
                self.broadcastLayer.isHidden = false
                self.step1.isHidden = false
                self.step6.isHidden = true
                self.step8.isHidden = true
            }
            else if !Session.instance.step7 {
                self.issueLayer.isHidden = false
                self.processLayer.isHidden = true
                self.broadcastLayer.isHidden = false
                self.step1.isHidden = true
                self.step6.isHidden = false
                self.step8.isHidden = true
            }
            else {
                self.issueLayer.isHidden = false
                self.processLayer.isHidden = false
                self.broadcastLayer.isHidden = true
                self.step1.isHidden = true
                self.step6.isHidden = true
                self.step8.isHidden = false
            }
        }
//        else {
//            self.dboardLayer1.isHidden = true
//            self.dboardLayer2.isHidden = true
//            self.dboardLayer3.isHidden = true
//            self.issueLayer.isHidden = true
//            self.processLayer.isHidden = true
//            self.broadcastLayer.isHidden = true
//            self.step1.isHidden = true
//            self.step6.isHidden = true
//            self.step8.isHidden = true
//        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return Reachability.instance.checkNetwork()
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
        self.setDefaultBusinessView(issueBool, viewType: "autoIssue")
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
        self.setDefaultBusinessView(processBool, viewType: "autoProcess")
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
        self.setDefaultBusinessView(broadcastBool, viewType: "autoBroadcast")
    }
    
    
    func setDefaultBusinessView(_ boolVal: Bool, viewType: String) {
        let preferences = UserDefaults.standard
        if boolVal {
            preferences.set(viewType, forKey: "defaultView")
        }
        else {
            preferences.removeObject(forKey: "defaultView")
        }
        preferences.synchronize()
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
                            self.tabBarController!.selectedIndex = 0
                            SwiftSpinner.hide()
                        })
                        return
                    }
                    let responseData = JSON(data: response.data!)
                    debugPrint(responseData)
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
            self.markDefaultBusinessView(dv)
            self.performSegue(withIdentifier: dv, sender: self)
        }
    }
    
    func markDefaultBusinessView(_ dv: String) {
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
