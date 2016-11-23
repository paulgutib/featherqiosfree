//
//  FQIssueNumberViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQIssueNumberViewController: UIViewController {

    @IBOutlet weak var numToIssue: UILabel!
    @IBOutlet weak var issueSpecific: UIStepper!
    @IBOutlet weak var issueBtn: UIButton!
    @IBOutlet weak var timeForecast: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.issueBtn.layer.cornerRadius = 5.0
        self.issueBtn.clipsToBounds = true
        self.issueSpecific.value = 16.0
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

    @IBAction func incrementDecrement(_ sender: UIStepper) {
        self.numToIssue.text = "\(Int(sender.value))"
    }
    
    @IBAction func issueNumber(_ sender: Any) {
        let alertBox = UIAlertController(title: "SUCCESS", message: self.numToIssue.text! + " has been issued. Estimated time until called is around " + self.timeForecast.text! + ". Thanks!", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertBox, animated: true, completion: nil)
    }
}
