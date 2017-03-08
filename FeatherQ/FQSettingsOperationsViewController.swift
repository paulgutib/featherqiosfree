//
//  FQSettingsOperationsViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/2/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreLocation

class FQSettingsOperationsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var lastNumber: UITextField!
    @IBOutlet weak var timeClose: UIDatePicker!
    @IBOutlet weak var timeOpen: UIDatePicker!
    
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
    var deviceToken: String?
    var latitudeLoc: String?
    var longitudeLoc: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.submitBtn.layer.cornerRadius = 10.0
        self.submitBtn.clipsToBounds = true
        self.firstNumber.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.lastNumber.inputAccessoryView = UIView.init()
        
        self.firstNumber.text = "\(Session.instance.numberStart!)"
        self.lastNumber.text = "\(Session.instance.numberLimit!)"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "h:mm a"
        self.timeClose.date = df.date(from: Session.instance.timeClose!)!
        self.timeOpen.date = df.date(from: Session.instance.timeOpen!)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.submitBtn.backgroundColor = Session.instance.currentTheme!
        self.submitBtn.setTitleColor(Session.instance.currentThemeText!, for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func timeClosePicker(_ sender: UIDatePicker) {
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = .short
//        timeFormatter.locale = Locale(identifier: "en_US")
//        self.timeCloseVal = timeFormatter.string(from: sender.date)
    }
    
    @IBAction func timeOpenPicker(_ sender: UIDatePicker) {
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = .short
//        timeFormatter.locale = Locale(identifier: "en_US")
//        self.timeOpenVal = timeFormatter.string(from: sender.date)
    }
    
    @IBAction func firstNumberTxt(_ sender: UITextField) {
        self.lastNumber.becomeFirstResponder()
    }
    
    @IBAction func lastNumberTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }

    @IBAction func updateAccount(_ sender: UIButton) {
        if self.filledUpRequiredFields() {
            self.generateCoordinatesFromAddress(closure: {
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                timeFormatter.locale = Locale(identifier: "en_US")
                let timeOpenVal = timeFormatter.string(from: self.timeOpen.date)
                let timeCloseVal = timeFormatter.string(from: self.timeClose.date)
                Alamofire.request(Router.postUpdateBusiness(business_id: Session.instance.businessId, name: Session.instance.businessName!, address: Session.instance.address!, logo: Session.instance.logo!, category: Session.instance.category!, time_open: timeOpenVal, time_close: timeCloseVal, number_start: self.firstNumber.text!, number_limit: self.lastNumber.text!, longitudeVal: self.longitudeLoc!, latitudeVal: self.latitudeLoc!)).responseJSON { response in
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
                }
                Session.instance.timeClose = timeCloseVal
                Session.instance.timeOpen = timeOpenVal
                Session.instance.numberStart = Int(self.firstNumber.text!)!
                Session.instance.numberLimit = Int(self.lastNumber.text!)!
                self.navigationController!.popViewController(animated: true)
            })
        }
    }
    
    func filledUpRequiredFields() -> Bool {
        let fNum = self.firstNumber.text!
        let lNum = self.lastNumber.text!
        if fNum.isEmpty || lNum.isEmpty || Int(fNum) == nil || Int(lNum) == nil {
            let alertBox = UIAlertController(title: "Required First/Last Numbers", message: "Make sure that you specify the first and last numbers of your line correctly.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if Int(fNum)! > Int(lNum)! {
            let alertBox = UIAlertController(title: "First Number is Invalid", message: "The first number must be lesser than the last number.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.timeOpen.date >= self.timeClose.date {
            let alertBox = UIAlertController(title: "Invalid Business Hours", message: "Provide an opening and a closing time for your business. Closing time must be later than the opening time.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func generateCoordinatesFromAddress(closure: @escaping () -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(Session.instance.address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                debugPrint(error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.latitudeLoc = "\(coordinates.latitude)"
                self.longitudeLoc = "\(coordinates.longitude)"
                debugPrint(self.latitudeLoc!)
                debugPrint(self.longitudeLoc!)
                closure()
            }
        })
    }
    
}
