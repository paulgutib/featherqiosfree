//
//  FQOnboardingLayerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/25/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingLayerViewController: UIViewController {

    @IBOutlet weak var searchMask: UIView!
    @IBOutlet weak var locationMask: UIView!
    @IBOutlet weak var businessMask: UIView!
    @IBOutlet weak var locationHelper: UIView!
    @IBOutlet weak var searchHelper: UIView!
    @IBOutlet weak var listHelper: UIView!
    @IBOutlet weak var menuHelper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationMask.isHidden = true
        self.searchMask.isHidden = false
        self.businessMask.isHidden = false
        self.locationHelper.isHidden = false
        self.searchHelper.isHidden = true
        self.listHelper.isHidden = true
        self.menuHelper.isHidden = true
        self.locationHelper.layer.borderColor = UIColor.black.cgColor
        self.locationHelper.layer.borderWidth = 2.0
        self.locationHelper.layer.cornerRadius = 5.0
        self.locationHelper.clipsToBounds = true
        self.searchHelper.layer.borderColor = UIColor.black.cgColor
        self.searchHelper.layer.borderWidth = 2.0
        self.searchHelper.layer.cornerRadius = 5.0
        self.searchHelper.clipsToBounds = true
        self.listHelper.layer.borderColor = UIColor.black.cgColor
        self.listHelper.layer.borderWidth = 2.0
        self.listHelper.layer.cornerRadius = 5.0
        self.listHelper.clipsToBounds = true
        self.menuHelper.layer.borderColor = UIColor.black.cgColor
        self.menuHelper.layer.borderWidth = 2.0
        self.menuHelper.layer.cornerRadius = 5.0
        self.menuHelper.clipsToBounds = true
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
    
    @IBAction func locationTap(_ sender: UITapGestureRecognizer) {
        self.locationMask.isHidden = false
        self.searchMask.isHidden = true
        self.businessMask.isHidden = false
        self.locationHelper.isHidden = true
        self.searchHelper.isHidden = false
        self.listHelper.isHidden = true
        self.menuHelper.isHidden = true
    }
    
    @IBAction func searchTap(_ sender: UITapGestureRecognizer) {
        self.locationMask.isHidden = false
        self.searchMask.isHidden = false
        self.businessMask.isHidden = true
        self.locationHelper.isHidden = true
        self.searchHelper.isHidden = true
        self.listHelper.isHidden = false
        self.menuHelper.isHidden = true
    }
    
    @IBAction func listTap(_ sender: UITapGestureRecognizer) {
        self.locationMask.isHidden = false
        self.searchMask.isHidden = false
        self.businessMask.isHidden = false
        self.locationHelper.isHidden = true
        self.searchHelper.isHidden = true
        self.listHelper.isHidden = true
        self.menuHelper.isHidden = false
    }
    
    @IBAction func menuTap(_ sender: UITapGestureRecognizer) {
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "fqiosappfreeonboard")
        preferences.synchronize()
        self.dismiss(animated: false, completion: nil)
        UIApplication.shared.keyWindow?.viewWithTag(1111)?.removeFromSuperview()
        UIApplication.shared.keyWindow?.viewWithTag(2222)?.removeFromSuperview()
    }
    
}
