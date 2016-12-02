//
//  FQSettingsOperationsViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/2/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQSettingsOperationsViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstNumber.text = "\(Session.instance.numberStart!)"
        self.lastNumber.text = "\(Session.instance.numberLimit!)"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "h:mm a"
        self.timeClose.date = df.date(from: Session.instance.timeClose!)!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func timeClosePicker(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "en_US")
        self.timeCloseVal = timeFormatter.string(from: sender.date)
    }
    
    @IBAction func firstNumberTxt(_ sender: UITextField) {
        self.lastNumber.becomeFirstResponder()
    }
    
    @IBAction func lastNumberTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }

    @IBAction func updateAccount(_ sender: UIButton) {
        SwiftSpinner.show("Updating..")
        Alamofire.request(Router.putBusiness(business_id: Session.instance.businessId, name: Session.instance.businessName!, address: Session.instance.address!, category: Session.instance.category!, time_close: self.timeCloseVal!, number_start: self.firstNumber.text!, number_limit: self.lastNumber.text!)).responseJSON { response in
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
            Session.instance.timeClose = self.timeCloseVal!
            Session.instance.numberStart = Int(self.firstNumber.text!)!
            Session.instance.numberLimit = Int(self.lastNumber.text!)!
            SwiftSpinner.hide()
        }
    }
}
