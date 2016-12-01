//
//  FQVerificationCodeViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/25/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQVerificationCodeViewController: UIViewController {

    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var modalContainer: UIView!
    
    var confirmationCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.verifyBtn.layer.cornerRadius = 5.0
        self.verifyBtn.clipsToBounds = true
        self.modalContainer.layer.cornerRadius = 5.0
        self.modalContainer.clipsToBounds = true
        self.verificationCode.inputAccessoryView = UIView.init()
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
    
    @IBAction func verificationCodeTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func submitVerifyCode(_ sender: UIButton) {
        if self.verificationCode.text! == self.confirmationCode! {
            let alertBox = UIAlertController(title: "Success", message: "Your email has been verified.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
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
