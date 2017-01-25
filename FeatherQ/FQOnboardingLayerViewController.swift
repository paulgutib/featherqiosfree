//
//  FQOnboardingLayerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/25/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingLayerViewController: UIViewController {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionContent: UILabel!
    @IBOutlet weak var searchMask: UIView!
    @IBOutlet weak var locationMask: UIView!
    @IBOutlet weak var businessMask: UIView!
    
    var onboardingSections = [
        [
            "title": "Search",
            "content": "Entering the business' name, address, or its unique 4-character code enables you to preview its current line progress."
        ],
        [
            "title": "Business List",
            "content": "You will be able to know the number of people lining up and the estimated time they will be served without even visiting the establishment."
        ],
        [
            "title": "Categories",
            "content": "You can filter the Business List to show only businesses belonging to specific industry."
        ],
        [
            "title": "Nearby",
            "content": "FeatherQ is capable of listing businesses that are near you. The globe above will ask permission to allow the app to access your current location."
        ]
    ]
    var sectionCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sectionTitle.text = onboardingSections[0]["title"]
        self.sectionContent.text = onboardingSections[0]["content"]
        self.locationMask.isHidden = false
        self.searchMask.isHidden = true
        self.businessMask.isHidden = false
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

    @IBAction func tapContinue(_ sender: UIButton) {
        self.sectionCounter += 1
        if self.sectionCounter == 1 {
            self.locationMask.isHidden = false
            self.searchMask.isHidden = false
            self.businessMask.isHidden = true
        }
        else if self.sectionCounter == 2 {
            self.locationMask.isHidden = false
            self.searchMask.isHidden = false
            self.businessMask.isHidden = false
        }
        else if self.sectionCounter == 3 {
            self.locationMask.isHidden = true
            self.searchMask.isHidden = false
            self.businessMask.isHidden = false
        }
        if self.sectionCounter < 4 {
            self.sectionTitle.text = onboardingSections[self.sectionCounter]["title"]
            self.sectionContent.text = onboardingSections[self.sectionCounter]["content"]
        }
        else {
            let preferences = UserDefaults.standard
            preferences.set(true, forKey: "fqiosappfreeonboard")
            preferences.synchronize()
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            appdelegate.window?.rootViewController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "startMainApp")
            self.dismiss(animated: false, completion: nil)
            UIApplication.shared.keyWindow?.viewWithTag(1111)?.removeFromSuperview()
            UIApplication.shared.keyWindow?.viewWithTag(2222)?.removeFromSuperview()
        }
    }
    
}
