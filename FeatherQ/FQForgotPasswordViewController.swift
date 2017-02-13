//
//  FQForgotPasswordViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/28/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sendBtn.layer.cornerRadius = 10.0
        self.sendBtn.clipsToBounds = true
        self.email.inputAccessoryView = UIView.init()
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
    
    @IBAction func emailTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }

    @IBAction func sendRequest(_ sender: UIButton) {
        if self.emailValidity() {
            SwiftSpinner.show("Requesting..")
            Alamofire.request(Router.postResetPassword(email: self.email.text!)).responseJSON { response in
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
                if responseData["success"] != nil {
                    let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FQChangePasswordViewController") as! FQChangePasswordViewController
                    modalViewController.confirmToken = responseData["code"].stringValue
                    modalViewController.userEmail = self.email.text!
                    modalViewController.modalPresentationStyle = .overCurrentContext
                    self.present(modalViewController, animated: true, completion: nil)
                }
                else {
                    let alertBox = UIAlertController(title: "User Not Found", message: "Please enter the email address you registered for FeatherQ.", preferredStyle: .alert)
                    alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertBox, animated: true, completion: nil)
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    func emailValidity() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: self.email.text!) {
            let alertBox = UIAlertController(title: "Invalid Email", message: "Email address must have the correct email format.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
}
