//
//  FQSettingsThemesTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 3/8/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQSettingsThemesTableViewController: UITableViewController {
    
    let themeList = [
        [0.0, 1.0, 0.0], // green
        [1.0, 0.0, 0.0], // red
        [0.0, 1.0, 1.0], // cyan
        [0.6, 0.4, 0.2], // brown
        [0.0, 0.0, 1.0], // blue
        [1.0, 0.0, 1.0], // magenta
        [0.498, 0.0, 0.498], // purple
        [1.0, 1.0, 0.0], // yellow
        [0.851, 0.4471, 0.0902] // default
    ] as [[CGFloat]]
    
    let fontTextColor = [
        ["black", UIColor.black], // green
        ["white", UIColor.white], // red
        ["black", UIColor.black], // cyan
        ["white", UIColor.white], // brown
        ["white", UIColor.white], // blue
        ["white", UIColor.white], // magenta
        ["white", UIColor.white], // purple
        ["black", UIColor.black], // yellow
        ["white", UIColor.white] // default
    ]

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(self.themeList[indexPath.row])
        let alertBox = UIAlertController(title: "Confirm", message: "Are you sure you want to apply this theme?", preferredStyle: .actionSheet)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            self.setGlobalTheme(rowCount: indexPath.row)
            self.setCurrentTheme(rowCount: indexPath.row)
            let preferences = UserDefaults.standard
            preferences.set(self.themeList[indexPath.row], forKey: "fqiosappfreetheme")
            preferences.set(self.fontTextColor[indexPath.row][0], forKey: "fqiosappfreethemetext")
            preferences.synchronize()
            Session.instance.currentTheme = UIColor(red: self.themeList[indexPath.row][0], green: self.themeList[indexPath.row][1], blue: self.themeList[indexPath.row][2], alpha: 1.0)
            Session.instance.currentThemeText = self.fontTextColor[indexPath.row][1] as? UIColor
            let alertBox = UIAlertController(title: "SUCCESS", message: "The selected theme has been applied.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        if let popoverController = alertBox.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertBox, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func resetTheme(_ sender: UIBarButtonItem) {
        let alertBox = UIAlertController(title: "Confirm", message: "Are you sure you want to switch back to the default theme?", preferredStyle: .actionSheet)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            self.setGlobalTheme(rowCount: 8)
            self.setCurrentTheme(rowCount: 8)
            let preferences = UserDefaults.standard
            preferences.set(self.themeList[8], forKey: "fqiosappfreetheme")
            preferences.set(self.fontTextColor[8][0], forKey: "fqiosappfreethemetext")
            preferences.synchronize()
            Session.instance.currentTheme = UIColor(red: self.themeList[8][0], green: self.themeList[8][1], blue: self.themeList[8][2], alpha: 1.0)
            Session.instance.currentThemeText = self.fontTextColor[8][1] as? UIColor
            let alertBox = UIAlertController(title: "SUCCESS", message: "The selected theme has been applied.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        if let popoverController = alertBox.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertBox, animated: true, completion: nil)
    }
    
    func setGlobalTheme(rowCount: Int) {
        UINavigationBar.appearance().barTintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : self.fontTextColor[rowCount][1] as! UIColor]
        UINavigationBar.appearance().tintColor = self.fontTextColor[rowCount][1] as! UIColor
        UITabBar.appearance().tintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
        UIButton.appearance().tintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
        UITableView.appearance().tintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
        UISegmentedControl.appearance().tintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
    }
    
    func setCurrentTheme(rowCount: Int) {
        self.navigationController!.navigationBar.barTintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : self.fontTextColor[rowCount][1] as! UIColor]
        self.navigationController!.navigationBar.tintColor = self.fontTextColor[rowCount][1] as! UIColor
        self.navigationController!.tabBarController!.tabBar.tintColor = UIColor(red: self.themeList[rowCount][0], green: self.themeList[rowCount][1], blue: self.themeList[rowCount][2], alpha: 1.0)
    }

}
