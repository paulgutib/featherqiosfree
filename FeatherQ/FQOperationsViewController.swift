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
    @IBOutlet weak var timeOpen: UIDatePicker!
    @IBOutlet weak var numbersHelp: UIView!
    
    var email: String?
    var password: String?
    var logoPath: String?
    var businessName: String?
    var selectedCategory: String?
    var selectedCountry: String?
    var buildingOffice: String?
    var streetBlock: String?
    var townCity: String?
    var stateProvince: String?
    var zipPostalCode: String?
    var phone: String?
    var deviceToken: String?
    var barangaySublocality: String?
    var longitudeVal: String?
    var latitudeVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.submitBtn.layer.cornerRadius = 5.0
        self.submitBtn.clipsToBounds = true
        self.numbersHelp.layer.cornerRadius = 5.0
        self.numbersHelp.clipsToBounds = true
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
    
    @IBAction func timeOpenPicker(_ sender: UIDatePicker) {
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = .short
//        timeFormatter.locale = Locale(identifier: "en_US")
//        self.timeOpenVal = timeFormatter.string(from: sender.date)
    }
    
    @IBAction func timeClosePicker(_ sender: UIDatePicker) {
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = .short
//        timeFormatter.locale = Locale(identifier: "en_US")
//        self.timeCloseVal = timeFormatter.string(from: sender.date)
    }

    @IBAction func registerAccount(_ sender: UIButton) {
        if self.filledUpRequiredFields() {
            SwiftSpinner.show("Please wait..")
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeFormatter.locale = Locale(identifier: "en_US")
            let timeOpenVal = timeFormatter.string(from: self.timeOpen.date)
            let timeCloseVal = timeFormatter.string(from: self.timeClose.date)
            let completeAddress = self.buildingOffice! + ", " + self.streetBlock! + ", " + self.barangaySublocality! + ", " + self.townCity! + ", " + /*self.zipPostalCode! + ", " +*/ self.stateProvince! + ", " + self.selectedCountry!
            Alamofire.request(Router.postRegister(email: self.email!, password: self.password!, name: self.businessName!, address: completeAddress, logo: self.logoPath!, category: self.selectedCategory!, time_open: timeOpenVal, time_close: timeCloseVal, number_start: self.firstNumber.text!, number_limit: self.lastNumber.text!, deviceToken: Session.instance.deviceToken!, longitudeVal: self.longitudeVal!, latitudeVal: self.latitudeVal!)).responseJSON { response in
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
                        Session.instance.timeClose = timeCloseVal
                        Session.instance.timeOpen = timeOpenVal
                        Session.instance.numberLimit = Int(self.lastNumber.text!)!
                        Session.instance.numberStart = Int(self.firstNumber.text!)!
                        Session.instance.address = completeAddress
                        Session.instance.businessName = self.businessName!
                        Session.instance.businessId = "\(responseData["business_id"])"
                        Session.instance.serviceId = "\(responseData["service_id"])"
                        Session.instance.key = responseData["raw_code"].stringValue
                        Session.instance.logo = self.logoPath!
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
    
    func filledUpRequiredFields() -> Bool {
        let fNum = self.firstNumber.text!
        let lNum = self.lastNumber.text!
        if fNum.isEmpty || lNum.isEmpty || Int(fNum) == nil || Int(lNum) == nil {
            let alertBox = UIAlertController(title: "Required First/Last Numbers", message: "Make sure that you specify the first and last numbers of your line correctly.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if Int(fNum)! > Int(lNum)! {
            let alertBox = UIAlertController(title: "First Number is Invalid", message: "The first number must be lesser than the last number.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.timeOpen.date >= self.timeClose.date {
            let alertBox = UIAlertController(title: "Invalid Business Hours", message: "Provide an opening and a closing time for your business. Closing time must be later than the opening time.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
}
