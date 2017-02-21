//
//  FQIssueNumberClosedViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 2/6/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQIssueNumberClosedViewController: UIViewController {
    
    var timerCounter: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timerCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallbacks), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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

    @IBAction func gobackDashboard(_ sender: UIButton) {
        let tabBarController = self.view.window?.rootViewController as! UITabBarController
        let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
        var rootViewControllers = tabBarController.viewControllers
        rootViewControllers?[2] = vc
        vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
        tabBarController.setViewControllers(rootViewControllers, animated: false)
        tabBarController.selectedIndex = 2
    }
    
    func timerCallbacks() {
        if Session.instance.punchType == "Play" {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
