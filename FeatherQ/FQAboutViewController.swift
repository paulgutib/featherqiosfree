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

    @IBOutlet weak var logOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.logOutBtn.layer.cornerRadius = 5.0
        self.logOutBtn.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "fqiosappfree")
        if dictionary != nil {
            self.logOutBtn.isHidden = false
        }
        else {
            self.logOutBtn.isHidden = true
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

    @IBAction func logoutAccount(_ sender: UIButton) {
        let alertBox = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            do{
                try Locksmith.deleteDataForUserAccount(userAccount: "fqiosappfree")
                debugPrint("logged out")
            }catch {
                debugPrint(error)
            }
            UserDefaults.standard.removeObject(forKey: "defaultView")
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "getStartedIntro")
            var rootViewControllers = self.tabBarController?.viewControllers
            rootViewControllers?[2] = vc
            vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
            self.tabBarController?.setViewControllers(rootViewControllers, animated: false)
            self.tabBarController?.selectedIndex = 0
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        self.present(alertBox, animated: true, completion: nil)
        return
    }
    
}
