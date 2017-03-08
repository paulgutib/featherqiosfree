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
    @IBOutlet weak var confirmationCode: UILabel!
    @IBOutlet weak var estimatedCallTime: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var modalContainer: UIView!
    
    @IBOutlet weak var step4: UIView!
    
    var confirmCode: String?
    var issuedNum: String?
    var timeEstimate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.okBtn.layer.cornerRadius = 10.0
        self.okBtn.clipsToBounds = true
        self.modalContainer.layer.cornerRadius = 10.0
        self.modalContainer.clipsToBounds = true
        
        self.priorityNumber.text = self.issuedNum!
        self.confirmationCode.text = self.confirmCode!
        self.estimatedCallTime.text = self.timeEstimate!
        
        self.step4.layer.cornerRadius = 10.0
        self.step4.clipsToBounds = true
        self.step4.layer.borderWidth = 2.0
        self.step4.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.okBtn.backgroundColor = Session.instance.currentTheme!
        self.okBtn.setTitleColor(Session.instance.currentThemeText!, for: .normal)
        if !UserDefaults.standard.bool(forKey: "fqiosappfreeonboardbusiness") {
            self.step4.isHidden = false
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

    @IBAction func okDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
