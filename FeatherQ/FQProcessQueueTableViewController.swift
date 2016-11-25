//
//  FQProcessQueueTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/16/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQProcessQueueTableViewController: UITableViewController {
    
    var priorityNumbers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        for i in 1 ... 100 {
            self.priorityNumbers.append(i)
        }
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
        return self.priorityNumbers.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FQProcessQueueTableViewCell", for: indexPath) as! FQProcessQueueTableViewCell

        // Configure the cell...
        cell.priorityNum.text = "\(self.priorityNumbers[indexPath.row])"
        cell.runningTime.text = "08:21"
        cell.notesValue.text = "Chickenjoy, Burger Steak"
        cell.callNum.tag = indexPath.row

        return cell
    }

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
    
    @IBAction func callNumNow(_ sender: UIButton) {
        let serveNum = UIButton(frame: CGRect(x: sender.frame.origin.x, y: sender.frame.origin.y, width: (sender.frame.width / 2.0) - 5.0, height: sender.frame.height))
        serveNum.layer.cornerRadius = 5.0
        serveNum.clipsToBounds = true
        serveNum.setTitle("Serve", for: .normal)
        serveNum.setTitleColor(UIColor.white, for: .normal)
        serveNum.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
        serveNum.backgroundColor = UIColor(red: 0.2275, green: 0.549, blue: 0.0902, alpha: 1.0) /* #3a8c17 */
        serveNum.addTarget(self, action: #selector(self.serveNumNow(sender:)), for: .touchUpInside)
        serveNum.tag = sender.tag
        
        let dropNum = UIButton(frame: CGRect(x: sender.frame.origin.x + (sender.frame.width / 2.0) + 5.0, y: sender.frame.origin.y, width: (sender.frame.width / 2.0) - 5.0, height: sender.frame.height))
        dropNum.layer.cornerRadius = 5.0
        dropNum.clipsToBounds = true
        dropNum.setTitle("Drop", for: .normal)
        dropNum.setTitleColor(UIColor.white, for: .normal)
        dropNum.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
        dropNum.backgroundColor = UIColor(red: 0.9725, green: 0.298, blue: 0.0157, alpha: 1.0) /* #f84c04 */
        dropNum.addTarget(self, action: #selector(self.dropNumNow(sender:)), for: .touchUpInside)
        dropNum.tag = sender.tag
        
        sender.isHidden = true
        sender.superview!.addSubview(serveNum)
        sender.superview!.addSubview(dropNum)
    }
    
    func serveNumNow(sender: UIButton) {
        debugPrint("served tagged \(sender.tag)")
        self.priorityNumbers.remove(at: sender.tag)
        self.tableView.reloadData()
    }
    
    func dropNumNow(sender: UIButton) {
        debugPrint("dropped tagged \(sender.tag)")
        self.priorityNumbers.remove(at: sender.tag)
        self.tableView.reloadData()
    }
}
