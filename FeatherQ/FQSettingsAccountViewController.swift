//
//  FQSettingsAccountViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/2/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQSettingsAccountViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateBtn.layer.cornerRadius = 5.0
        self.updateBtn.clipsToBounds = true
        self.email.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.password.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.confirmPassword.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    /*
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
        self.confirmPassword.becomeFirstResponder()
    }
    
    @IBAction func confirmPasswordTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func updateAccount(_ sender: UIButton) {
        
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
