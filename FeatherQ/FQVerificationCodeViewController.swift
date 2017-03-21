//
//  FQVerificationCodeViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/25/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQVerificationCodeViewController: UIViewController {

    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var modalContainer: UIView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var codeHelp: UIView!
    
    var confirmationCode: String?
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.verifyBtn.layer.cornerRadius = 10.0
        self.verifyBtn.clipsToBounds = true
        self.codeHelp.layer.cornerRadius = 10.0
        self.codeHelp.clipsToBounds = true
        self.resendBtn.layer.cornerRadius = 10.0
        self.resendBtn.clipsToBounds = true
        self.verificationCode.inputAccessoryView = UIView.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return Reachability.instance.checkNetwork()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toBusinessDetails" {
            if self.verificationCode.text! == self.confirmationCode! {
                let alertBox = UIAlertController(title: "Success", message: "Your email has been verified.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    let destView = segue.destination as! FQBusinessDetailsViewController
                    destView.email = self.email!
                    destView.password = self.password!
                    segue.perform()
                }))
                self.present(alertBox, animated: true, completion: nil)
            }
            else {
                let alertBox = UIAlertController(title: "Incorrect Verification Code", message: "Please enter the verification code sent to your email.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
                return
            }
        }
    }
    
    @IBAction func verificationCodeTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func submitVerifyCode(_ sender: UIButton) {
        
    }

    @IBAction func resendCode(_ sender: UIButton) {
        SwiftSpinner.show("Sending verification code..")
        Alamofire.request(Router.postEmailVerification(email: self.email!)).responseJSON { response in
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
            self.confirmationCode = responseData["code"].stringValue
            let alertBox = UIAlertController(title: "Success", message: "A new verification code has been sent to your email.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            SwiftSpinner.hide()
        }
    }
    
}
