//
//  FQRegistrationViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import SwiftSpinner

class FQRegistrationViewController: UIViewController {

    @IBOutlet weak var next1Btn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.next1Btn.layer.cornerRadius = 5.0
        self.next1Btn.clipsToBounds = true
        self.email.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.password.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.confirmPassword.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toBusinessDetails" {
            if self.emailPasswordValidity() {
                SwiftSpinner.show("Sending verification code..")
                let destView = segue.destination as! FQBusinessDetailsViewController
                destView.email = self.email.text!
                destView.password = self.password.text!
                segue.perform()
                let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FQVerificationCodeViewController") as! FQVerificationCodeViewController
                modalViewController.modalPresentationStyle = .overCurrentContext
                self.present(modalViewController, animated: true, completion: {
                    SwiftSpinner.hide()
                })
            }
        }
    }

    @IBAction func verifyAccount(_ sender: UIButton) {
        
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
        else if self.password.text != self.confirmPassword.text || self.password.text!.isEmpty || self.confirmPassword.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Password", message: "Passwords must not be empty and need to match.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
}
