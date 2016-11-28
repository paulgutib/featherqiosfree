//
//  FQLoginViewController.swift
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

class FQLoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loginBtn.layer.cornerRadius = 5.0
        self.loginBtn.clipsToBounds = true
        self.email.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.password.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
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
        self.password.becomeFirstResponder()
    }
    
    @IBAction func passwordTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func signUpReset(_ sender: UIButton) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func loginAccount(_ sender: UIButton) {
        SwiftSpinner.show("Logging in..")
        Alamofire.request(Router.postLogin(email: self.email.text!, password: self.password.text!)).responseJSON { response in
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
                        "email": self.email.text!,
                        "password": self.password.text!
                    ], forUserAccount: "fqiosappfree")
                    let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
                    var rootViewControllers = self.tabBarController?.viewControllers
                    rootViewControllers?[2] = vc
                    vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
                    self.tabBarController?.setViewControllers(rootViewControllers, animated: false)
                }catch {
                    debugPrint(error)
                }
            }
            else {
                let alertBox = UIAlertController(title: "Account Doesn't Exist", message: "The credentials you entered doesn't match any accounts. Please try again.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            }
            SwiftSpinner.hide()
        }
    }
    
}
