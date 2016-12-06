//
//  FQIssueNumberViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQIssueNumberViewController: UIViewController {

    @IBOutlet weak var numToIssue: UILabel!
    @IBOutlet weak var issueSpecific: UIStepper!
    @IBOutlet weak var issueBtn: UIButton!
    @IBOutlet weak var timeForecast: UILabel!
    @IBOutlet weak var notes: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.notes.inputAccessoryView = UIView.init()
        self.issueBtn.layer.cornerRadius = 5.0
        self.issueBtn.clipsToBounds = true
        for i in Session.instance.numberStart! ... Session.instance.numberLimit! {
            let iString = "\(i)"
            if !Session.instance.takenNumbers.contains(iString) {
                Session.instance.availableNumbers.append(i)
            }
        }
        self.numToIssue.text = "\(Session.instance.availableNumbers[0])"
        self.issueSpecific.maximumValue = Double(Session.instance.availableNumbers.count-1)
        self.issueSpecific.minimumValue = 0.0
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
    @IBAction func notesTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }

    @IBAction func incrementDecrement(_ sender: UIStepper) {
        self.numToIssue.text = "\(Session.instance.availableNumbers[Int(sender.value)])"
    }
    
    @IBAction func issueNumber(_ sender: Any) {
        SwiftSpinner.show("Issuing number..")
        Alamofire.request(Router.postIssueNumber(service_id: Session.instance.serviceId!, priority_number: self.numToIssue.text!, note: self.notes.text!)).responseJSON { response in
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
            if responseData["number"] != nil {
                let dataObj = responseData["number"].dictionaryObject!
                let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FQReceiptViewController") as! FQReceiptViewController
                modalViewController.issuedNum = self.numToIssue.text!
                modalViewController.timeEstimate = self.timeForecast.text!
                modalViewController.transactionNum = "\(dataObj["transaction_number"]!)"
                modalViewController.confirmCode = dataObj["confirmation_code"] as? String
                modalViewController.modalPresentationStyle = .overCurrentContext
                Session.instance.availableNumbers.remove(at: Session.instance.availableNumbers.index(of: Int(self.numToIssue.text!)!)!)
                self.numToIssue.text = "\(Session.instance.availableNumbers[0])"
                self.issueSpecific.maximumValue = Double(Session.instance.availableNumbers.count-1)
                self.issueSpecific.value = 0.0
                self.notes.text = ""
                self.present(modalViewController, animated: true, completion: nil)
            }
            else {
                let alertBox = UIAlertController(title: "Number Taken", message: "Please issue an available number.", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            }
            SwiftSpinner.hide()
        }
    }
}
