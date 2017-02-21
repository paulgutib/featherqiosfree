//
//  FQSettingsTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/1/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Locksmith

class FQSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return 1
        }
        return 5
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            let alertBox = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
            alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                do{
                    try Locksmith.deleteDataForUserAccount(userAccount: "fqiosappfree")
                    debugPrint("logged out")
                }catch {
                    debugPrint(error)
                }
                self.navigationController!.popToRootViewController(animated: true)
                Session.instance.isLoggedIn = false
                UserDefaults.standard.removeObject(forKey: "defaultView")
                UserDefaults.standard.removeObject(forKey: "fqiosappfreeloggedin")
                let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "getStartedIntro")
                var rootViewControllers = self.tabBarController?.viewControllers
                rootViewControllers?[2] = vc
                vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
                self.tabBarController?.setViewControllers(rootViewControllers, animated: false)
                self.tabBarController?.selectedIndex = 0
            }))
            alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
            if let popoverController = alertBox.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(alertBox, animated: true, completion: nil)
            return nil
        }
        return indexPath
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
