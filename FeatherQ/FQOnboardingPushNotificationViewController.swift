//
//  FQOnboardingPushNotificationViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/30/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingPushNotificationViewController: UIViewController {

    @IBOutlet weak var grantPermission: UIButton!
    @IBOutlet weak var locationNotify: UILabel!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var timerCounter: Timer?
    
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
        self.locationNotify.isHidden = true
        self.settingsBtn.isHidden = true
        self.grantPermission.isHidden = true
        self.timerCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallbacks), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timerCounter?.invalidate()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func allowPushNotifs(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "fqiosappfreenotification")
        preferences.synchronize()
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    @IBAction func goToAppSettings(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    func timerCallbacks() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            self.dismiss(animated: true, completion: nil)
        }
        else if UserDefaults.standard.bool(forKey: "fqiosappfreenotification") {
            self.locationNotify.isHidden = false
            self.settingsBtn.isHidden = false
            self.grantPermission.isHidden = true
        }
        else {
            self.locationNotify.isHidden = true
            self.settingsBtn.isHidden = true
            self.grantPermission.isHidden = false
        }
    }

}
