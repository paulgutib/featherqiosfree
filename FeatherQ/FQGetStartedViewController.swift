//
//  FQGetStartedViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/15/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQGetStartedViewController: UIViewController {

    @IBOutlet weak var startUsing: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startUsing.layer.cornerRadius = 5.0
        self.startUsing.clipsToBounds = true
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

}
