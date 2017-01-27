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
    @IBOutlet weak var noAvailableNum: UILabel!
    
    @IBOutlet weak var step5: UIView!
    @IBOutlet weak var step2: UIView!
    @IBOutlet weak var step3: UIView!
    @IBOutlet weak var numberLayer: UIView!
    @IBOutlet weak var dboardLayer1: UIView!
    @IBOutlet weak var dboardLayer2: UIView!
    @IBOutlet weak var dboardLayer3: UIView!
    @IBOutlet weak var buttonLayer: UIView!
    
    var takenNumbers = [String]()
    var availableNumbers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.notes.inputAccessoryView = UIView.init()
        self.issueBtn.layer.cornerRadius = 5.0
        self.issueBtn.clipsToBounds = true
        self.noAvailableNum.layer.cornerRadius = 5.0
        self.noAvailableNum.clipsToBounds = true
        
        self.step5.layer.cornerRadius = 5.0
        self.step5.clipsToBounds = true
        self.step5.layer.borderWidth = 2.0
        self.step5.layer.borderColor = UIColor.black.cgColor
        self.step2.layer.cornerRadius = 5.0
        self.step2.clipsToBounds = true
        self.step2.layer.borderWidth = 2.0
        self.step2.layer.borderColor = UIColor.black.cgColor
        self.step3.layer.cornerRadius = 5.0
        self.step3.clipsToBounds = true
        self.step3.layer.borderWidth = 2.0
        self.step3.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("Preparing..")
        Alamofire.request(Router.getAllNumbers(business_id: Session.instance.businessId)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    self.navigationController!.popViewController(animated: true)
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            if responseData["numbers"] != nil {
                self.takenNumbers.removeAll()
                self.availableNumbers.removeAll()
                for numberList in responseData["numbers"]["unprocessed_numbers"] {
                    let dataObj = numberList.1.dictionaryObject!
                    let pNum = "\(dataObj["priority_number"]!)"
                    self.takenNumbers.append(pNum)
                }
                for i in Session.instance.numberStart! ... Session.instance.numberLimit! {
                    let iString = "\(i)"
                    if !self.takenNumbers.contains(iString) {
                        self.availableNumbers.append(i)
                    }
                }
                if !self.availableNumbers.isEmpty {
                    self.getEstimatedTime()
                    self.numToIssue.text = "\(self.availableNumbers[0])"
                    self.issueSpecific.maximumValue = Double(self.availableNumbers.count-1)
                    self.issueSpecific.isEnabled = true
                    self.notes.isEnabled = true
                    self.noAvailableNum.isHidden = true
                    self.issueBtn.isEnabled = true
                    self.issueBtn.backgroundColor = UIColor(red: 0.2275, green: 0.549, blue: 0.0902, alpha: 1.0) /* #3a8c17 */
                }
                else {
                    self.numToIssue.text = ""
                    self.issueSpecific.maximumValue = 1
                    self.issueSpecific.isEnabled = false
                    self.notes.isEnabled = false
                    self.noAvailableNum.isHidden = false
                    self.timeForecast.text = "-"
                    self.issueBtn.isEnabled = false
                    self.issueBtn.backgroundColor = UIColor.gray
                }
                self.issueSpecific.minimumValue = 0.0
            }
            SwiftSpinner.hide()
        }
        
        self.step5.isHidden = true
        self.step2.isHidden = false
        self.step3.isHidden = false
        self.numberLayer.isHidden = true
        self.buttonLayer.isHidden = true
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
        self.numToIssue.text = "\(self.availableNumbers[Int(sender.value)])"
//        let totalSecs = (sender.value + 1) * Double(Session.instance.estimatedSecs!)
//        self.showEstimatedTimeText(Int(totalSecs))
    }
    
    @IBAction func issueNumber(_ sender: Any) {
        SwiftSpinner.show("Issuing number..")
        debugPrint(self.numToIssue.text!)
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
                modalViewController.confirmCode = dataObj["confirmation_code"] as? String
                modalViewController.modalPresentationStyle = .overCurrentContext
                self.availableNumbers.remove(at: self.availableNumbers.index(of: Int(self.numToIssue.text!)!)!)
                if !self.availableNumbers.isEmpty {
                    self.numToIssue.text = "\(self.availableNumbers[0])"
                    self.issueSpecific.maximumValue = Double(self.availableNumbers.count-1)
                    self.issueSpecific.isEnabled = true
                    self.notes.isEnabled = true
                    self.noAvailableNum.isHidden = true
                    self.issueBtn.isEnabled = true
                    self.issueBtn.backgroundColor = UIColor(red: 0.2275, green: 0.549, blue: 0.0902, alpha: 1.0) /* #3a8c17 */
                    self.getEstimatedTime()
                }
                else {
                    self.numToIssue.text = ""
                    self.issueSpecific.maximumValue = 1
                    self.issueSpecific.isEnabled = false
                    self.notes.isEnabled = false
                    self.noAvailableNum.isHidden = false
                    self.issueBtn.isEnabled = false
                    self.issueBtn.backgroundColor = UIColor.gray
                    self.timeForecast.text = "-"
                }
                self.issueSpecific.value = 0.0
                self.notes.text = ""
                
                Session.instance.step4 = true
                self.step5.isHidden = false
                self.step2.isHidden = true
                self.step3.isHidden = true
                self.numberLayer.isHidden = false
                self.buttonLayer.isHidden = false
                
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
    
    func getEstimatedTime() {
        Alamofire.request(Router.getEstimatedTime(business_id: Session.instance.businessId)).responseJSON { response in
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
            let servingTime = responseData["estimated_serving_time"].intValue
            let peopleInLine = responseData["people_in_line"].intValue
            let totalSecs = servingTime * peopleInLine
            self.showEstimatedTimeText(totalSecs: totalSecs)
        }
    }
    
    func showEstimatedTimeText(totalSecs: Int) {
        let date = Date()
        let upperBound = date.addingTimeInterval(Double(totalSecs))
//        let lowerBound = date.addingTimeInterval(Double(totalSecs) - (10.0 * 60.0))
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "h:mm a"
//        self.timeForecast.text = df.string(from: lowerBound) + " ~ " + df.string(from: upperBound)
        self.timeForecast.text = df.string(from: upperBound)
    }
    
}

