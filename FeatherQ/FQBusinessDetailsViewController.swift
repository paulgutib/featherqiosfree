//
//  FQBusinessDetailsViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQBusinessDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var next2Btn: UIButton!
    @IBOutlet weak var logoPic: UIImageView!
    @IBOutlet weak var categoryList: UIPickerView!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var removeLogoBtn: UIButton!
    @IBOutlet weak var chooseLogoBtn: UIButton!
    
    var categoryEntry = [
        ["name": "- Select a Category -", "image": ""],
        ["name": "Agriculture", "image": "CatAgriculture"],
        ["name": "Energy", "image": "CatEnergy"],
        ["name": "Mining and Quarrying", "image": "CatMining"],
        ["name": "Manufacturing", "image": "CatManufacturing"],
        ["name": "Government", "image": "CatGovernment"],
        ["name": "Construction", "image": "CatConstruction"],
        ["name": "Wholesale and Retail", "image": "CatRetail"],
        ["name": "Hotels and Restaurants", "image": "CatHotel"],
        ["name": "Transportation", "image": "CatTransportation"],
        ["name": "Telecommunications", "image": "CatTelecommunications"],
        ["name": "Financial", "image": "CatFinancial"],
        ["name": "Education", "image": "CatEducation"],
        ["name": "Social Services", "image": "CatSocial"],
        ["name": "Health Care", "image": "CatHealth"],
        ["name": "Technology", "image": "CatTechnology"],
        ["name": "Entertainment", "image": "CatEntertainment"],
        ["name": "Mass Media", "image": "CatMedia"]
    ]
    var selectedCategory = "- Select a Category -"
    var email: String?
    var password: String?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.next2Btn.layer.cornerRadius = 5.0
        self.next2Btn.clipsToBounds = true
        self.chooseLogoBtn.layer.cornerRadius = 5.0
        self.chooseLogoBtn.clipsToBounds = true
        self.removeLogoBtn.layer.cornerRadius = 5.0
        self.removeLogoBtn.clipsToBounds = true
        imagePicker.delegate = self
        self.businessName.inputAccessoryView = UIView.init() // removes IQKeyboardManagerSwift toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.logoPic.contentMode = .scaleToFill
            self.logoPic.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryEntry.count
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryEntry[row]["name"]!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.categoryEntry[row]["name"]!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toBusinessValidation" {
            if self.validateBusinessNameCategory() {
                let destView = segue.destination as! FQBusinessValidationViewController
                destView.email = self.email!
                destView.password = self.password!
                destView.businessName = self.businessName.text!
                destView.selectedCategory = self.selectedCategory
            }
        }
    }
    
    @IBAction func chooseLogo(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func removeLogo(_ sender: UIButton) {
        self.logoPic.image = UIImage(named: "PlaceholderLogo")
    }
    
    func validateBusinessNameCategory() -> Bool {
        if self.businessName.text!.isEmpty {
            let alertBox = UIAlertController(title: "Invalid Business Name", message: "Please enter the name of your business.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        else if self.selectedCategory == "- Select a Category -" {
            let alertBox = UIAlertController(title: "Invalid Category", message: "Please select an appropriate category for your business.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            return false
        }
        return true
    }
}
