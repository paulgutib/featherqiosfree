//
//  FQOnboardingLocationViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/17/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit
import CoreLocation

class FQOnboardingLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var grantPermission: UIButton!
    @IBOutlet weak var locationNotify: UILabel!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var cllManager = CLLocationManager()
    var latitudeLoc: String?
    var longitudeLoc: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.grantPermission.layer.cornerRadius = 10.0
        self.grantPermission.clipsToBounds = true
        self.locationNotify.layer.cornerRadius = 10.0
        self.locationNotify.clipsToBounds = true
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "fqiosappfreelocation") == "denied" {
            self.locationNotify.isHidden = false
            self.settingsBtn.isHidden = false
            self.allowLocating(self.grantPermission)
        }
        else {
            self.locationNotify.isHidden = true
            self.settingsBtn.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        debugPrint(self.isLocationUpdated)
        //        if !self.isLocationUpdated {
        let userLocation = locations[0]
        self.latitudeLoc = "\(userLocation.coordinate.latitude)"
        self.longitudeLoc = "\(userLocation.coordinate.longitude)"
        self.cllManager.stopUpdatingLocation()
        //            self.isLocationUpdated = true
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationApprovalCallback()
            debugPrint("granted when in use")
        case .authorizedAlways:
            self.locationApprovalCallback()
            debugPrint("granted always")
        case .denied:
            let preferences = UserDefaults.standard
            preferences.set("denied", forKey: "fqiosappfreelocation")
            preferences.synchronize()
            self.locationNotify.isHidden = false
            self.settingsBtn.isHidden = false
            debugPrint("denied must change")
        default:
            let preferences = UserDefaults.standard
            preferences.set("denied", forKey: "fqiosappfreelocation")
            preferences.synchronize()
            self.locationNotify.isHidden = false
            self.settingsBtn.isHidden = false
            debugPrint("denied must change")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func allowLocating(_ sender: UIButton) {
        sender.isHidden = true
        self.cllManager.delegate = self
        self.cllManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cllManager.requestWhenInUseAuthorization()
        self.cllManager.startUpdatingLocation()
    }
    
    @IBAction func goToAppSettings(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    func locationApprovalCallback() {
        let preferences = UserDefaults.standard
        preferences.set("granted", forKey: "fqiosappfreelocation")
        preferences.synchronize()
        self.locationNotify.isHidden = true
        self.settingsBtn.isHidden = true
        let alertBox = UIAlertController(title: "SUCCESS", message: "Your current location is now being used by the application.", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
            self.navigationController!.popToRootViewController(animated: true)
        }))
        self.present(alertBox, animated: true, completion: nil)
    }
}
