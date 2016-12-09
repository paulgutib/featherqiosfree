//
//  FQChangePasswordViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/9/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQChangePasswordViewController: UIViewController {

    @IBOutlet weak var modalContainer: UIView!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmNewPass: UITextField!
    @IBOutlet weak var tokenCode: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var confirmToken: String?
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalContainer.layer.cornerRadius = 5.0
        self.modalContainer.clipsToBounds = true
        self.submitBtn.layer.cornerRadius = 5.0
        self.submitBtn.clipsToBounds = true
        self.newPass.inputAccessoryView = UIView.init()
        self.confirmNewPass.inputAccessoryView = UIView.init()
        self.tokenCode.inputAccessoryView = UIView.init()
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

    @IBAction func newPassTxt(_ sender: UITextField) {
        self.confirmNewPass.becomeFirstResponder()
    }
    
    @IBAction func confirmNewPassTxt(_ sender: UITextField) {
        self.tokenCode.becomeFirstResponder()
    }
    
    @IBAction func tokenCodeTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func submitChange(_ sender: UIButton) {
        if self.newPass.text != self.confirmNewPass.text || self.newPass.text!.isEmpty || self.confirmNewPass.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Password", message: "Passwords must not be empty and need to match.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return
        }
        else if self.tokenCode.text! != self.confirmToken! {
            let alertBox = UIAlertController(title: "Incorrect Token", message: "Please enter the token sent to your email.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return
        }
        else {
            SwiftSpinner.show("Changing password..")
            Alamofire.request(Router.putChangePassword(email: self.userEmail!, password: self.newPass.text!, password_confirm: self.confirmNewPass.text!, verification_code: self.confirmToken!)).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error!)
//                    let errorMessage = (response.result.error?.localizedDescription)! as String
//                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
//                        SwiftSpinner.hide()
//                    })
//                    return
                }
                let responseData = JSON(data: response.data!)
                debugPrint(responseData)
                let alertBox = UIAlertController(title: "Success", message: "Your password has been changed.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertBox, animated: true, completion: nil)
                SwiftSpinner.hide()
            }
        }
    }
}
