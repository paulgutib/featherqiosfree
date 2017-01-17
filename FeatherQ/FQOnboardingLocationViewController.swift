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
    @IBOutlet weak var locationGuide: UILabel!
    
    var cllManager = CLLocationManager()
    var latitudeLoc: String?
    var longitudeLoc: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.grantPermission.layer.cornerRadius = 5.0
        self.grantPermission.clipsToBounds = true
        self.locationNotify.layer.cornerRadius = 5.0
        self.locationNotify.clipsToBounds = true
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "fqiosappfreelocation") == "denied" {
            self.locationNotify.isHidden = false
            self.locationGuide.isHidden = false
            self.allowLocating(self.grantPermission)
        }
        else {
            self.locationNotify.isHidden = true
            self.locationGuide.isHidden = true
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
            UserDefaults.standard.set("denied", forKey: "fqiosappfreelocation")
            self.locationNotify.isHidden = false
            self.locationGuide.isHidden = false
            debugPrint("denied must change")
        default:
            UserDefaults.standard.set("denied", forKey: "fqiosappfreelocation")
            self.locationNotify.isHidden = false
            self.locationGuide.isHidden = false
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
    
    func locationApprovalCallback() {
        UserDefaults.standard.set("granted", forKey: "fqiosappfreelocation")
        self.locationNotify.isHidden = true
        self.locationGuide.isHidden = true
        let alertBox = UIAlertController(title: "SUCCESS", message: "Your current location is now being used by the application.", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "FQOnboardingContainerViewController")
            self.present(vc, animated: true, completion: nil)
        }))
        self.present(alertBox, animated: true, completion: nil)
    }
}
