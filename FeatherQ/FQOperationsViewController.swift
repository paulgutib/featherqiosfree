//
//  FQOperationsViewController.swift
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

class FQOperationsViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var lastNumber: UITextField!
    @IBOutlet weak var timeClose: UIDatePicker!
    
    var email: String?
    var password: String?
    var logoVal: String?
    var businessName: String?
    var selectedCategory: String?
    var selectedCountry: String?
    var buildingOffice: String?
    var streetBlock: String?
    var townCity: String?
    var stateProvince: String?
    var zipPostalCode: String?
    var phone: String?
    var timeOpenVal: String?
    var timeCloseVal: String?
    var deviceToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.submitBtn.layer.cornerRadius = 5.0
        self.submitBtn.clipsToBounds = true
        self.firstNumber.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.lastNumber.inputAccessoryView = UIView.init()
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
    
    @IBAction func firstNumberTxt(_ sender: UITextField) {
        self.lastNumber.becomeFirstResponder()
    }
    
    @IBAction func lastNumberTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func timeClosePicker(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "en_US")
        self.timeCloseVal = timeFormatter.string(from: sender.date)
    }

    @IBAction func registerAccount(_ sender: UIButton) {
        SwiftSpinner.show("Please wait..")
        let completeAddress = self.buildingOffice! + ", " + self.streetBlock! + ", " + self.townCity! + ", " + self.stateProvince! + ", " + self.selectedCountry! + ", " + self.zipPostalCode!
        Alamofire.request(Router.postRegister(email: self.email!, password: self.password!, name: self.businessName!, address: completeAddress, logo: "", category: self.selectedCategory!, time_close: self.timeCloseVal!, number_start: self.firstNumber.text!, number_limit: self.lastNumber.text!, deviceToken: Session.instance.deviceToken!)).responseJSON { response in
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
                        "email": self.email!,
                        "password": self.password!,
                        "device_token": Session.instance.deviceToken!
                    ], forUserAccount: "fqiosappfree")
                    Session.instance.isLoggedIn = true
                    Session.instance.category = self.selectedCategory!
                    Session.instance.timeClose = self.timeCloseVal!
                    Session.instance.numberLimit = Int(self.lastNumber.text!)!
                    Session.instance.numberStart = Int(self.firstNumber.text!)!
                    Session.instance.address = completeAddress
                    Session.instance.businessName = self.businessName!
//                    Session.instance.businessId = responseData["business_id"].intValue
                    let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
                    var rootViewControllers = self.tabBarController?.viewControllers
                    rootViewControllers?[2] = vc
                    vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
                    self.tabBarController?.setViewControllers(rootViewControllers, animated: false)
                }catch {
                    debugPrint(error)
                }
            }
            else{
                let alertBox = UIAlertController(title: "Server Error", message: "There was a connection error with our servers. Please try submitting again.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            }
            SwiftSpinner.hide()
        }
    }
}
