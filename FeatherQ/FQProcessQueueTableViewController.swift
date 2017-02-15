//
//  FQProcessQueueTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/16/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Foundation
import MGSwipeTableCell
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQProcessQueueTableViewController: UITableViewController {
    
    @IBOutlet weak var pauseResumeBtn: UIBarButtonItem!
    @IBOutlet weak var stopIssueBtn: UIBarButtonItem!

    var processQueue = [[String:String]]()
    var timerCounter: Timer?
    var transactionNums = [String]()
    var isPaused = false
    var punchType = "Play"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if !UserDefaults.standard.bool(forKey: "fqiosappfreeonboardbusiness") {
            self.tableView.tableHeaderView = self.howToCallServed()
            let queueLayer = UIView(frame: CGRect(x: 0.0, y: 360.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-360.0))
            queueLayer.tag = 3333
            queueLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            let dropLayer = UIView(frame: CGRect(x: UIScreen.main.bounds.width-120.0, y: 184.0, width: 120.0, height: 176.0))
            dropLayer.tag = 4444
            dropLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            UIApplication.shared.keyWindow?.addSubview(queueLayer)
            UIApplication.shared.keyWindow?.addSubview(dropLayer)
        }
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.viewWithTag(3333)?.removeFromSuperview()
        UIApplication.shared.keyWindow?.viewWithTag(4444)?.removeFromSuperview()
        self.timerCounter?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("Preparing..")
        Alamofire.request(Router.getAllNumbers(business_id: Session.instance.businessId)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    self.navigationController!.popViewController(animated: true)
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            if responseData != nil {
                Session.instance.punchType = responseData["punch_type"].stringValue
            }
            if responseData["numbers"] != nil {
                self.processQueue.removeAll()
                for numberList in responseData["numbers"]["unprocessed_numbers"] {
                    let dataObj = numberList.1.dictionaryObject!
                    self.transactionNums.append("\(dataObj["priority_number"]!)")
                    self.processQueue.append([
                        "transaction_number": "\(dataObj["transaction_number"]!)",
                        "priority_number": "\(dataObj["priority_number"]!)",
                        "confirmation_code": dataObj["confirmation_code"] as! String,
                        "time_queued": "\(dataObj["time_queued"]!)",
                        "notes": dataObj["note"] as! String,
                        "time_called": "\(dataObj["time_called"]!)",
                    ])
                }
                Session.instance.transactionNums = self.transactionNums
                debugPrint(self.processQueue)
                Session.instance.processQueue = self.processQueue
                self.tableView.reloadData()
            }
            SwiftSpinner.hide()
        }
        self.timerCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallbacks), userInfo: nil, repeats: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.processQueue.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FQProcessQueueTableViewCell", for: indexPath) as! FQProcessQueueTableViewCell

        // Configure the cell...
        let timeIssued = Date(timeIntervalSince1970: Double(self.processQueue[indexPath.row]["time_queued"]!)!)
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "hh:mm a"
        cell.runningTime.text = df.string(from: timeIssued as Date)
        cell.priorityNum.text = self.processQueue[indexPath.row]["priority_number"]
        cell.confirmCode.text = self.processQueue[indexPath.row]["confirmation_code"]
        cell.notesValue.text = self.processQueue[indexPath.row]["notes"]
        cell.serveNum.tag = indexPath.row
        cell.dropNum.tag = indexPath.row
//        cell.callNum.tag = indexPath.row
        
        if self.processQueue[indexPath.row]["time_called"] != "0" {
            cell.callNum.isHidden = true
            cell.serveNum.isHidden = false
            cell.dropNum.isHidden = false
//            cell.buttonContainer.subviews.forEach({ $0.removeFromSuperview() })
//            cell.buttonContainer.addSubview(self.renderServeButton(indexPath: indexPath, cell: cell))
//            cell.buttonContainer.addSubview(self.renderDropButton(indexPath: indexPath, cell: cell))
        }
        else {
            cell.callNum.isHidden = false
            cell.serveNum.isHidden = true
            cell.dropNum.isHidden = true
        }
        
        //configure left buttons
        if indexPath.row < self.processQueue.count-1 {
            cell.leftButtons = [MGSwipeButton(title: "Serve and Call Next", icon: UIImage(named:"check.png"), backgroundColor: UIColor(red: 0, green: 0.4588, blue: 0.0667, alpha: 1.0)/* #007511 */, callback: { (sender: MGSwipeTableCell!) -> Bool in
                self.serveCallNext(indexPath)
                return true
            })]
            cell.leftSwipeSettings.transition = .drag
            
            //configure right buttons
            cell.rightButtons = [MGSwipeButton(title: "Serve and Call Next", icon: UIImage(named:"check.png"), backgroundColor: UIColor(red: 0, green: 0.4588, blue: 0.0667, alpha: 1.0) /* #007511 */, callback: { (sender: MGSwipeTableCell!) -> Bool in
                self.serveCallNext(indexPath)
                return true
            })]
            cell.rightSwipeSettings.transition = .drag
            
            cell.leftExpansion.buttonIndex = 0
            cell.leftExpansion.fillOnTrigger = true
            cell.rightExpansion.buttonIndex = 0
            cell.rightExpansion.fillOnTrigger = true
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

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
        Session.instance.step7 = true
        let cell = sender.superview?.superview?.superview as! FQProcessQueueTableViewCell // buttonContainer -> cellContentView -> cell
        let indexPath = self.tableView.indexPath(for: cell)
        self.processQueue[indexPath!.row]["time_called"] = "\(Date().timeIntervalSince1970)"
        Alamofire.request(Router.getCallNumber(transaction_number: self.processQueue[indexPath!.row]["transaction_number"]!)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
        }
        self.tableView.reloadData()
    }
    
//    func renderServeButton(indexPath: IndexPath, cell: FQProcessQueueTableViewCell) -> UIButton {
//        let serveNum = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (cell.buttonContainer.frame.width / 2.0) - 5.0, height: cell.buttonContainer.frame.height))
//        serveNum.layer.cornerRadius = 10.0
//        serveNum.clipsToBounds = true
//        serveNum.setTitle("Serve", for: .normal)
//        serveNum.setTitleColor(UIColor.white, for: .normal)
//        serveNum.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
//        serveNum.backgroundColor = UIColor(red: 0.2275, green: 0.549, blue: 0.0902, alpha: 1.0) /* #3a8c17 */
//        serveNum.tag = indexPath.row
//        serveNum.addTarget(self, action: #selector(self.serveNumNow(sender:)), for: .touchUpInside)
//        return serveNum
//    }
//    
//    func renderDropButton(indexPath: IndexPath, cell: FQProcessQueueTableViewCell) -> UIButton {
//        let dropNum = UIButton(frame: CGRect(x: (cell.buttonContainer.frame.width / 2.0) + 5.0, y: 0.0, width: (cell.buttonContainer.frame.width / 2.0) - 5.0, height: cell.buttonContainer.frame.height))
//        dropNum.layer.cornerRadius = 10.0
//        dropNum.clipsToBounds = true
//        dropNum.setTitle("Drop", for: .normal)
//        dropNum.setTitleColor(UIColor.white, for: .normal)
//        dropNum.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
//        dropNum.backgroundColor = UIColor(red: 0.9725, green: 0.298, blue: 0.0157, alpha: 1.0) /* #f84c04 */
//        dropNum.tag = indexPath.row
//        dropNum.addTarget(self, action: #selector(self.dropNumNow(sender:)), for: .touchUpInside)
//        return dropNum
//    }
    
    @IBAction func pauseResumeQueue(_ sender: UIBarButtonItem) {
        var breakResumeMessage: String?
        if self.isPaused {
            breakResumeMessage = "Do you want to start processing numbers?"
        }
        else {
            breakResumeMessage = "Do you want to take a break?"
        }
        let alertBox = UIAlertController(title: breakResumeMessage, message: "The line status will be updated on the broadcast screen.", preferredStyle: .actionSheet)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            var punchType: String?
            self.stopIssueBtn.isEnabled = true
            self.isPaused = !self.isPaused
            if self.isPaused {
                SwiftSpinner.show("Taking a break..")
                self.pauseResumeBtn.image = UIImage(named: "PlayButton")
                punchType = "Pause"
            }
            else {
                SwiftSpinner.show("Getting ready to resume..")
                self.pauseResumeBtn.image = UIImage(named: "PauseButton")
                punchType = "Play"
            }
            Alamofire.request(Router.postPunchQueuestatus(service_id: Session.instance.serviceId!, punch_type: punchType!)).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error!)
                    let errorMessage = (response.result.error?.localizedDescription)! as String
                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                let responseData = JSON(data: response.data!)
                debugPrint(responseData)
                SwiftSpinner.hide();
            }
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        if let popoverController = alertBox.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertBox, animated: true, completion: nil)
    }
    
    @IBAction func stopIssuingNumbers(_ sender: UIBarButtonItem) {
        let alertBox = UIAlertController(title: "Do you want to stop issuing more numbers?", message: "Once done, the issuing of numbers will be disabled but you must still process the numbers in the line.", preferredStyle: .actionSheet)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            SwiftSpinner.show("Closing the line..")
            self.isPaused = true
            self.pauseResumeBtn.image = UIImage(named: "PlayButton")
            self.stopIssueBtn.isEnabled = false
            Alamofire.request(Router.postPunchQueuestatus(service_id: Session.instance.serviceId!, punch_type: "Stop")).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error!)
                    let errorMessage = (response.result.error?.localizedDescription)! as String
                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                let responseData = JSON(data: response.data!)
                debugPrint(responseData)
                SwiftSpinner.hide();
            }
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        if let popoverController = alertBox.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertBox, animated: true, completion: nil)
    }
    
    @IBAction func dropNumNow(_ sender: UIButton) {
        let alertBox = UIAlertController(title: "Are you sure you want to drop this number?", message: "Dropping this number will mean that the customer will no longer show up to the line.", preferredStyle: .actionSheet)
        alertBox.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            debugPrint("dropped tagged \(sender.tag)")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            Alamofire.request(Router.getDropNumber(transaction_number: self.processQueue[indexPath.row]["transaction_number"]!)).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error!)
                    let errorMessage = (response.result.error?.localizedDescription)! as String
                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                let responseData = JSON(data: response.data!)
                debugPrint(responseData)
            }
            self.removeRowsAndReload(indexPath)
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        if let popoverController = alertBox.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX - 150.0, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alertBox, animated: true, completion: nil)
    }
    
    @IBAction func serveNumNow(_ sender: UIButton) {
        debugPrint("served tagged \(sender.tag)")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        Alamofire.request(Router.getServeNumber(transaction_number: self.processQueue[indexPath.row]["transaction_number"]!)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
        }
        self.removeRowsAndReload(indexPath)
    }
    
    func serveCallNext(_ indexPath: IndexPath) {
        self.processQueue[indexPath.row+1]["time_called"] = "\(Date().timeIntervalSince1970)"
        Alamofire.request(Router.getServeNumber(transaction_number: self.processQueue[indexPath.row]["transaction_number"]!)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            Alamofire.request(Router.getCallNumber(transaction_number: self.processQueue[indexPath.row]["transaction_number"]!)).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error!)
                    let errorMessage = (response.result.error?.localizedDescription)! as String
                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                let responseData = JSON(data: response.data!)
                debugPrint(responseData)
            }
        }
        self.removeRowsAndReload(indexPath)
    }
    
    func removeRowsAndReload(_ indexPath: IndexPath) {
        self.processQueue.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.reloadData()
    }
    
    func timerCallbacks() {
        if Session.instance.transactionNums != self.transactionNums {
            self.transactionNums = Session.instance.transactionNums
            self.processQueue = Session.instance.processQueue
            self.tableView.reloadData()
        }
        if Session.instance.punchType != self.punchType {
            self.punchType = Session.instance.punchType
            self.setLineStatusButtonStates(punchType: self.punchType)
        }
    }
    
    func howToCallServed() -> UIView {
        let wrapper = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 120.0))
        wrapper.backgroundColor = UIColor(red: 1, green: 1, blue: 0.7373, alpha: 1.0) /* #ffffbc */
        wrapper.layer.borderWidth = 2.0
        wrapper.layer.borderColor = UIColor.black.cgColor
        let howToTitle = UILabel(frame: CGRect(x: 0.0, y: 8.0, width: UIScreen.main.bounds.width, height: 18.0))
        howToTitle.text = "Step 7"
        howToTitle.textAlignment = .center
        howToTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        let howToContent = UILabel(frame: CGRect(x: 8.0, y: 34.0, width: UIScreen.main.bounds.width-8.0, height: 72.0))
        howToContent.text = "1. To call an issued number, tap \"Call\"\n2. To serve a called number, tap \"Serve\"\n3. After serving, go back to Dashboard."
        howToContent.font = UIFont.systemFont(ofSize: 15.0)
        howToContent.numberOfLines = 4
        wrapper.addSubview(howToTitle)
        wrapper.addSubview(howToContent)
        return wrapper
    }
    
    func setLineStatusButtonStates(punchType: String) {
        if punchType == "Play" {
            self.stopIssueBtn.isEnabled = true
            self.isPaused = false
            self.pauseResumeBtn.image = UIImage(named: "PauseButton")
        }
        else if punchType == "Pause" {
            self.stopIssueBtn.isEnabled = true
            self.isPaused = true
            self.pauseResumeBtn.image = UIImage(named: "PlayButton")
        }
        else {
            self.isPaused = true
            self.stopIssueBtn.isEnabled = false
            self.pauseResumeBtn.image = UIImage(named: "PlayButton")
        }
    }
    
}
