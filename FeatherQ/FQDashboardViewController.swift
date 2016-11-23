//
//  FQDashboardViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQDashboardViewController: UIViewController {

    @IBOutlet weak var processQueueBtn: UIButton!
    @IBOutlet weak var issueNumberBtn: UIButton!
    @IBOutlet weak var broadcastBtn: UIButton!
    @IBOutlet weak var issueDefault: UIButton!
    @IBOutlet weak var processDefault: UIButton!
    @IBOutlet weak var broadcastDefault: UIButton!
    
    var issueBool = false
    var processBool = false
    var broadcastBool = false
    
    let checkboxChecked = UIImage(named: "CheckboxChecked")
    let checkBoxEmpty = UIImage(named: "CheckboxEmpty")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.processQueueBtn.layer.cornerRadius = 5.0
        self.processQueueBtn.clipsToBounds = true
        self.issueNumberBtn.layer.cornerRadius = 5.0
        self.issueNumberBtn.clipsToBounds = true
        self.broadcastBtn.layer.cornerRadius = 5.0
        self.broadcastBtn.clipsToBounds = true
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
    
    @IBAction func issueSetDefault(_ sender: UIButton) {
        issueBool = !issueBool
        if issueBool {
            self.issueDefault.setImage(self.checkboxChecked, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        processBool = false
        broadcastBool = false
    }
    
    @IBAction func processSetDefault(_ sender: UIButton) {
        processBool = !processBool
        if processBool {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkboxChecked, for: .normal)
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        else {
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        issueBool = false
        broadcastBool = false
    }
    
    @IBAction func broadcastSetDefault(_ sender: UIButton) {
        broadcastBool = !broadcastBool
        if broadcastBool {
            self.issueDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.processDefault.setImage(self.checkBoxEmpty, for: .normal)
            self.broadcastDefault.setImage(self.checkboxChecked, for: .normal)
        }
        else {
            self.broadcastDefault.setImage(self.checkBoxEmpty, for: .normal)
        }
        processBool = false
        issueBool = false
    }
    
}
