//
//  FQAboutViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/29/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Locksmith

class FQAboutViewController: UIViewController {
    
    @IBOutlet var settingsBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showHideSettingsButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showHideSettingsButton()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func viewGuide(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "FQOnboardingContainerViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    func showHideSettingsButton() {
        if Session.instance.isLoggedIn {
            self.navigationItem.rightBarButtonItem = self.settingsBtn
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
}
