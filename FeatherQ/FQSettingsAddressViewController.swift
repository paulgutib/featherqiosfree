//
//  FQSettingsAddressViewController.swift
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

class FQSettingsAddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var countryList: UIPickerView!
    @IBOutlet weak var buildingOffice: UITextField!
    @IBOutlet weak var streetBlock: UITextField!
    @IBOutlet weak var townCity: UITextField!
    @IBOutlet weak var stateProvince: UITextField!
//    @IBOutlet weak var zipPostalCode: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var barangaySublocality: UITextField!
    
    var countryEntry = [
        "- Select a Country -",
        "Afghanistan",
        "Albania",
        "Algeria",
        "Andorra",
        "Angola",
        "Antigua and Barbuda",
        "Argentina",
        "Armenia",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas",
        "Bahrain",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bhutan",
        "Bolivia",
        "Bosnia and Herzegovina",
        "Botswana",
        "Brazil",
        "Brunei",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cabo Verde",
        "Cambodia",
        "Cameroon",
        "Canada",
        "Central African Republic (CAR)",
        "Chad",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Democratic Republic of the Congo",
        "Republic of the Congo",
        "Costa Rica",
        "Cote d'Ivoire",
        "Croatia",
        "Cuba",
        "Cyprus",
        "Czech Republic",
        "Denmark",
        "Djibouti",
        "Dominica",
        "Dominican Republic",
        "Ecuador",
        "Egypt",
        "El Salvador",
        "Equatorial Guinea",
        "Eritrea",
        "Estonia",
        "Ethiopia",
        "Fiji",
        "Finland",
        "France",
        "Gabon",
        "Gambia",
        "Georgia",
        "Germany",
        "Ghana",
        "Greece",
        "Grenada",
        "Guatemala",
        "Guinea",
        "Guinea-Bissau",
        "Guyana",
        "Haiti",
        "Honduras",
        "Hungary",
        "Iceland",
        "India",
        "Indonesia",
        "Iran",
        "Iraq",
        "Ireland",
        "Israel",
        "Italy",
        "Jamaica",
        "Japan",
        "Jordan",
        "Kazakhstan",
        "Kenya",
        "Kiribati",
        "Kosovo",
        "Kuwait",
        "Kyrgyzstan",
        "Laos",
        "Latvia",
        "Lebanon",
        "Lesotho",
        "Liberia",
        "Libya",
        "Liechtenstein",
        "Lithuania",
        "Luxembourg",
        "Macedonia",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldives",
        "Mali",
        "Malta",
        "Marshall Islands",
        "Mauritania",
        "Mauritius",
        "Mexico",
        "Micronesia",
        "Moldova",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Morocco",
        "Mozambique",
        "Myanmar (Burma)",
        "Namibia",
        "Nauru",
        "Nepal",
        "Netherlands",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "North Korea",
        "Norway",
        "Oman",
        "Pakistan",
        "Palau",
        "Palestine",
        "Panama",
        "Papua New Guinea",
        "Paraguay",
        "Peru",
        "Philippines",
        "Poland",
        "Portugal",
        "Qatar",
        "Romania",
        "Russia",
        "Rwanda",
        "Saint Kitts and Nevis",
        "Saint Lucia",
        "Saint Vincent and the Grenadines",
        "Samoa",
        "San Marino",
        "Sao Tome and Principe",
        "Saudi Arabia",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Slovakia",
        "Slovenia",
        "Solomon Islands",
        "Somalia",
        "South Africa",
        "South Korea",
        "South Sudan",
        "Spain",
        "Sri Lanka",
        "Sudan",
        "Suriname",
        "Swaziland",
        "Sweden",
        "Switzerland",
        "Syria",
        "Taiwan",
        "Tajikistan",
        "Tanzania",
        "Thailand",
        "Timor-Leste",
        "Togo",
        "Tonga",
        "Trinidad and Tobago",
        "Tunisia",
        "Turkey",
        "Turkmenistan",
        "Tuvalu",
        "Uganda",
        "Ukraine",
        "United Arab Emirates (UAE)",
        "United Kingdom (UK)",
        "United States of America (USA)",
        "Uruguay",
        "Uzbekistan",
        "Vanuatu",
        "Vatican City (Holy See)",
        "Venezuela",
        "Vietnam",
        "Yemen",
        "Zambia",
        "Zimbabwe"
    ]
    var email: String?
    var password: String?
    var logoVal: String?
    var businessName: String?
    var selectedCategory: String?
    var selectedCountry: String?
    var latitudeLoc: String?
    var longitudeLoc: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateBtn.layer.cornerRadius = 5.0
        self.updateBtn.clipsToBounds = true
        self.buildingOffice.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.streetBlock.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.townCity.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.stateProvince.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
//        self.zipPostalCode.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.phone.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
        self.logoVal = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let addressData = Session.instance.address!.components(separatedBy: ", ")
        self.buildingOffice.text = addressData[0]
        self.streetBlock.text = addressData[1]
        self.barangaySublocality.text = addressData[2]
        self.townCity.text = addressData[3]
        self.stateProvince.text = addressData[4]
        self.selectedCountry = addressData[5]
        self.countryList.selectRow(self.countryEntry.index(of: addressData[5])!, inComponent: 0, animated: true)
//        self.zipPostalCode.text = addressData[4]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func businessNameTxt(_ sender: UITextField) {
        self.streetBlock.becomeFirstResponder()
    }
    
    @IBAction func streetBlockTxt(_ sender: UITextField) {
        self.townCity.becomeFirstResponder()
    }
    
    @IBAction func townCityTxt(_ sender: UITextField) {
        self.stateProvince.becomeFirstResponder()
    }
    
    @IBAction func stateProvinceTxt(_ sender: UITextField) {
        self.phone.becomeFirstResponder()
    }
    
//    @IBAction func zipPostalCode(_ sender: UITextField) {
//        self.phone.becomeFirstResponder()
//    }
    
    @IBAction func phoneTxt(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    @IBAction func updateBusiness(_ sender: UIButton) {
        if self.validateAddresses() {
            self.generateCoordinatesFromAddress(closure: {
                let address1 = self.buildingOffice.text! + ", " + self.streetBlock.text! + ", "
                let address2 = self.barangaySublocality.text! + ", " + self.townCity.text! + ", "
                let address3 = /*self.zipPostalCode.text! + ", " + */self.stateProvince.text! + ", "
                let completeAddress = address1 + address2 + address3 + self.selectedCountry!
                Alamofire.request(Router.postUpdateBusiness(business_id: Session.instance.businessId, name: Session.instance.businessName!, address: completeAddress, logo: Session.instance.logo!, category: Session.instance.category!, time_open: Session.instance.timeOpen!, time_close: Session.instance.timeClose!, number_start: "\(Session.instance.numberStart!)", number_limit: "\(Session.instance.numberLimit!)", longitudeVal: self.longitudeLoc!, latitudeVal: self.latitudeLoc!)).responseJSON { response in
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
                Session.instance.address = completeAddress
                self.navigationController!.popViewController(animated: true)
            })
        }
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
//        else if self.zipPostalCode.text!.isEmpty {
//            let alertBox = UIAlertController(title: "Invalid Zip/Postal Code", message: "Please provide the correct zip or postal code on where your business is located.", preferredStyle: .alert)
//            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertBox, animated: true, completion: nil)
//            return false
//        }
        else if self.selectedCountry == "- Select a Country -" {
            let alertBox = UIAlertController(title: "Invalid Country", message: "Please select the country of your business location.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func generateCoordinatesFromAddress(closure: @escaping () -> Void) {
        let geocoder = CLGeocoder()
        let address1 = self.buildingOffice.text! + ", " + self.streetBlock.text! + ", "
        let address2 = self.barangaySublocality.text! + " " + self.townCity.text! + ", "
        let address3 = /*self.zipPostalCode.text! + " " + */self.stateProvince.text! + ", "
        let completeAddress = address1 + address2 + address3 + self.selectedCountry!
        geocoder.geocodeAddressString(completeAddress, completionHandler: {(placemarks, error) -> Void in
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
