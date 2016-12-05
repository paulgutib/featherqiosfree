//
//  FQReceiptViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/5/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQReceiptViewController: UIViewController {

    @IBOutlet weak var priorityNumber: UILabel!
    @IBOutlet weak var transactionNumber: UILabel!
    @IBOutlet weak var confirmationCode: UILabel!
    @IBOutlet weak var estimatedCallTime: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var modalContainer: UIView!
    
    var confirmCode: String?
    var issuedNum: String?
    var transactionNum: String?
    var timeEstimate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.okBtn.layer.cornerRadius = 5.0
        self.okBtn.clipsToBounds = true
        self.modalContainer.layer.cornerRadius = 5.0
        self.modalContainer.clipsToBounds = true
        
        self.priorityNumber.text = self.issuedNum!
        self.transactionNumber.text = self.transactionNum!
        self.confirmationCode.text = self.confirmCode!
        self.estimatedCallTime.text = self.timeEstimate!
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

    @IBAction func okDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
