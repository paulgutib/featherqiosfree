//
//  FQOnboardingUserTypeViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/19/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingUserTypeViewController: UIViewController {
    
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var ownerBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customerBtn.layer.cornerRadius = 5.0
        self.customerBtn.clipsToBounds = true
        self.ownerBtn.layer.cornerRadius = 5.0
        self.ownerBtn.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
