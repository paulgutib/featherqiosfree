//
//  FQOnboardingGetStartedViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/17/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingGetStartedViewController: UIViewController {

    @IBOutlet weak var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getStartedBtn.layer.cornerRadius = 5.0
        self.getStartedBtn.clipsToBounds = true
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

    @IBAction func getStarted(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "FQOnboardingLocationViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
}
