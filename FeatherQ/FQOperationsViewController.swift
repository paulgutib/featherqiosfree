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

class FQOperationsViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var timeOpen: UITextField!
    @IBOutlet weak var timeClose: UITextField!
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var lastNumber: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.submitBtn.layer.cornerRadius = 5.0
        self.submitBtn.clipsToBounds = true
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

    @IBAction func registerAccount(_ sender: UIButton) {
        SwiftSpinner.show("Please wait..")
        let completeAddress = self.buildingOffice! + ", " + self.streetBlock! + ", " + self.townCity! + ", " + self.stateProvince! + ", " + self.selectedCountry! + ", " + self.zipPostalCode!
        Alamofire.request(Router.postRegister(email: self.email!, password: self.password!, name: self.businessName!, address: completeAddress, logo: self.logoVal!, category: self.selectedCategory!, time_close: self.timeClose.text!, number_start: self.firstNumber.text!, number_limit: self.lastNumber.text!)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
//                let errorMessage = (response.result.error?.localizedDescription)! as String
//                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
//                    SwiftSpinner.hide()
//                })
//                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "FQDashboardViewController")
            self.present(vc, animated: true, completion: nil)
            SwiftSpinner.hide()
        }
    }
}
