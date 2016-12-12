//
//  FQBusinessValidationViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import CoreLocation

class FQBusinessValidationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var countryList: UIPickerView!
    @IBOutlet weak var next3Btn: UIButton!
    @IBOutlet weak var buildingOffice: UITextField!
    @IBOutlet weak var streetBlock: UITextField!
    @IBOutlet weak var barangaySublocality: UITextField!
    @IBOutlet weak var townCity: UITextField!
    @IBOutlet weak var stateProvince: UITextField!
    @IBOutlet weak var zipPostalCode: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var countryEntry = ["- Select a Country -", "Philippines", "China", "Russia", "USA", "Austrailia", "Singapore", "Japan"]
    var email: String?
    var password: String?
    var logoVal: String?
    var businessName: String?
    var selectedCategory: String?
    var selectedCountry = "- Select a Country -"
    var cllManager = CLLocationManager()
    var latitudeLoc: String?
    var longitudeLoc: String?
    var isLocationUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.next3Btn.layer.cornerRadius = 5.0
        self.next3Btn.clipsToBounds = true
        self.buildingOffice.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.streetBlock.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.townCity.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.stateProvince.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.zipPostalCode.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.phone.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.logoVal = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cllManager.delegate = self
        self.cllManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cllManager.requestWhenInUseAuthorization()
        self.cllManager.startUpdatingLocation()
    }
    
    @available(iOS 2.0, *)
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryEntry.count
    }
    
    @available(iOS 2.0, *)
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryEntry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = self.countryEntry[row]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.isLocationUpdated {
            let userLocation = locations[0]
            self.latitudeLoc = "\(userLocation.coordinate.latitude)"
            self.longitudeLoc = "\(userLocation.coordinate.longitude)"
            
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                if (error != nil) {
                    debugPrint("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                let townCity = (placemarks![0].locality != nil) ? placemarks![0].locality : ""
                let barangay = (placemarks![0].subLocality != nil) ? placemarks![0].subLocality : ""
                let postalCode = (placemarks![0].postalCode != nil) ? placemarks![0].postalCode : ""
                let streetAd = (placemarks![0].thoroughfare != nil) ? placemarks![0].thoroughfare : ""
                let streetAd2 = (placemarks![0].subThoroughfare != nil) ? placemarks![0].subThoroughfare : ""
                let stateProvince = (placemarks![0].administrativeArea != nil) ? placemarks![0].administrativeArea : ""
//                let stateProvince2 = (placemarks![0].subAdministrativeArea != nil) ? placemarks![0].subAdministrativeArea : ""
                let country = (placemarks![0].country != nil) ? placemarks![0].country : ""
                let countryIndex = (self.countryEntry.index(of: country!) != nil) ? self.countryEntry.index(of: country!) : 0
                self.countryList.selectRow(countryIndex!, inComponent: 0, animated: true)
                self.buildingOffice.text = streetAd2!
                self.streetBlock.text = streetAd!
                self.barangaySublocality.text = barangay!
                self.townCity.text = townCity!
                self.stateProvince.text = stateProvince!
                self.zipPostalCode.text = postalCode!
            })
            
            self.cllManager.stopUpdatingLocation()
            self.isLocationUpdated = true
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toBusinessOperations" {
            if self.validateAddresses() {
                let destView = segue.destination as! FQOperationsViewController
                destView.email = self.email!
                destView.password = self.password!
                destView.logoVal = self.logoVal!
                destView.businessName = self.businessName!
                destView.selectedCategory = self.selectedCategory!
                destView.selectedCountry = self.selectedCountry
                destView.buildingOffice = self.buildingOffice.text!
                destView.streetBlock = self.streetBlock.text!
                destView.townCity = self.townCity.text!
                destView.stateProvince = self.stateProvince.text!
                destView.zipPostalCode = self.zipPostalCode.text!
                destView.phone = self.phone.text!
                destView.barangaySublocality = self.barangaySublocality.text!
            }
        }
    }
    
    @IBAction func buildingOfficeTxt(_ sender: UITextField) {
        self.streetBlock.becomeFirstResponder()
    }
    
    @IBAction func streetBlockTxt(_ sender: UITextField) {
        self.barangaySublocality.becomeFirstResponder()
    }
    
    @IBAction func barangayTxt(_ sender: UITextField) {
        self.townCity.becomeFirstResponder()
    }
    
    @IBAction func townCity(_ sender: UITextField) {
        self.stateProvince.becomeFirstResponder()
    }
    
    @IBAction func stateProvince(_ sender: UITextField) {
        self.zipPostalCode.becomeFirstResponder()
    }
    
    @IBAction func zipPostalCodeTxt(_ sender: UITextField) {
        self.phone.becomeFirstResponder()
    }
    
    @IBAction func phoneTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    func validateAddresses() -> Bool {
        if self.streetBlock.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Street Address", message: "Please provide the correct street on where your business is located.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.townCity.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Town/City", message: "Please provide the correct town or city on where your business is located.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.stateProvince.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid State/Province", message: "Please provide the correct state or province on where your business is located.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.zipPostalCode.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Zip/Postal Code", message: "Please provide the correct zip or postal code on where your business is located.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.selectedCountry == "- Select a Country -" {
            let alertBox = UIAlertController(title: "Invalid Country", message: "Please select the country of your business location.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }

}
