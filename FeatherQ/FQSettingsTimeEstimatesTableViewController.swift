//
//  FQSettingsTimeEstimatesTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/17/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQSettingsTimeEstimatesTableViewController: UITableViewController {

    @IBOutlet weak var meanToday: UITextField!
    @IBOutlet weak var meanYesterday: UITextField!
    @IBOutlet weak var weightToday: UITextField!
    @IBOutlet weak var weightYesterday: UITextField!
    @IBOutlet weak var meanThreeDays: UITextField!
    @IBOutlet weak var weightThreeDays: UITextField!
    @IBOutlet weak var meanThisWeek: UITextField!
    @IBOutlet weak var weightThisWeek: UITextField!
    @IBOutlet weak var meanLastWeek: UITextField!
    @IBOutlet weak var weightLastWeek: UITextField!
    @IBOutlet weak var meanThisMonth: UITextField!
    @IBOutlet weak var weightThisMonth: UITextField!
    @IBOutlet weak var meanLastMonth: UITextField!
    @IBOutlet weak var weightLastMonth: UITextField!
    @IBOutlet weak var meanMostLikely: UITextField!
    @IBOutlet weak var weightMostLikely: UITextField!
    @IBOutlet weak var meanMostOptimistic: UITextField!
    @IBOutlet weak var weightMostOptimistic: UITextField!
    @IBOutlet weak var meanMostPessimistic: UITextField!
    @IBOutlet weak var weightMostPessimistic: UITextField!
    @IBOutlet weak var finalMean: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getMeanWeights()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
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
    
    @IBAction func saveMeanWeights(_ sender: UIBarButtonItem) {
        SwiftSpinner.show("Updating estimates..")
        Alamofire.request(Router.postUpdateMeanweights(meanToday: self.minsToSecsConversion(minutes: self.meanToday.text!), weightToday: self.weightToday.text!, meanYesterday: self.minsToSecsConversion(minutes: self.meanYesterday.text!), weightYesterday: self.weightYesterday.text!, meanThreeDays: self.minsToSecsConversion(minutes: self.meanThreeDays.text!), weightThreeDays: self.weightThreeDays.text!, meanThisWeek: self.minsToSecsConversion(minutes: self.meanThisWeek.text!), weightThisWeek: self.weightThisWeek.text!, meanLastWeek: self.minsToSecsConversion(minutes: self.meanLastWeek.text!), weightLastWeek: self.weightLastWeek.text!, meanThisMonth: self.minsToSecsConversion(minutes: self.meanThisMonth.text!), weightThisMonth: self.weightThisMonth.text!, meanLastMonth: self.minsToSecsConversion(minutes: self.meanLastMonth.text!), weightLastMonth: self.weightLastMonth.text!, meanMostLikely: self.minsToSecsConversion(minutes: self.meanMostLikely.text!), weightMostLikely: self.weightMostLikely.text!, meanMostOptimistic: self.minsToSecsConversion(minutes: self.meanMostOptimistic.text!), weightMostOptimistic: self.weightMostOptimistic.text!, meanMostPessimistic: self.minsToSecsConversion(minutes: self.meanMostPessimistic.text!), weightMostPessimistic: self.weightMostPessimistic.text!, serviceId: Session.instance.serviceId!)).responseJSON { response in
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
            if responseData["status"].intValue == 201 {
                self.getMeanWeights()
            }
            else {
                SwiftSpinner.show("Something went wrong..", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                }, subtitle: "We are unable to save your estimates. Kindly try again later.")
            }
        }
    }
    
    func getMeanWeights() {
        SwiftSpinner.show("Loading calculations..")
        Alamofire.request(Router.getMeanWeights(service_id: Session.instance.serviceId!)).responseJSON { response in
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
            if responseData != nil {
                self.meanToday.text = self.secsToMinsConversion(seconds: responseData["mean_today"].floatValue)
                self.weightToday = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightToday, meanVal: responseData["mean_today"].floatValue, weightVal: responseData["weight_today"].intValue)
                self.meanYesterday.text = self.secsToMinsConversion(seconds: responseData["mean_yesterday"].floatValue)
                self.weightYesterday = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightYesterday, meanVal: responseData["mean_yesterday"].floatValue, weightVal: responseData["weight_yesterday"].intValue)
                self.meanThreeDays.text = self.secsToMinsConversion(seconds: responseData["mean_three_days"].floatValue)
                self.weightThreeDays = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightThreeDays, meanVal: responseData["mean_three_days"].floatValue, weightVal: responseData["weight_three_days"].intValue)
                self.meanThisWeek.text = self.secsToMinsConversion(seconds: responseData["mean_this_week"].floatValue)
                self.weightThisWeek = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightThisWeek, meanVal: responseData["mean_this_week"].floatValue, weightVal: responseData["weight_this_week"].intValue)
                self.meanLastWeek.text = self.secsToMinsConversion(seconds: responseData["mean_last_week"].floatValue)
                self.weightLastWeek = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightLastWeek, meanVal: responseData["mean_last_week"].floatValue, weightVal: responseData["weight_last_week"].intValue)
                self.meanThisMonth.text = self.secsToMinsConversion(seconds: responseData["mean_this_month"].floatValue)
                self.weightThisMonth = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightThisMonth, meanVal: responseData["mean_this_month"].floatValue, weightVal: responseData["weight_this_month"].intValue)
                self.meanLastMonth.text = self.secsToMinsConversion(seconds: responseData["mean_last_month"].floatValue)
                self.weightLastMonth = self.excludeZeroWaitingTimeWeights(weightLbl: self.weightLastMonth, meanVal: responseData["mean_last_month"].floatValue, weightVal: responseData["weight_last_month"].intValue)
                self.meanMostLikely.text = self.secsToMinsConversion(seconds: responseData["mean_most_likely"].floatValue)
                self.weightMostLikely.text = "\(responseData["weight_most_likely"].intValue)"
                self.meanMostOptimistic.text = self.secsToMinsConversion(seconds: responseData["mean_most_optimistic"].floatValue)
                self.weightMostOptimistic.text = "\(responseData["weight_most_optimistic"].intValue)"
                self.meanMostPessimistic.text = self.secsToMinsConversion(seconds: responseData["mean_most_pessimistic"].floatValue)
                self.weightMostPessimistic.text = "\(responseData["weight_most_pessimistic"].intValue)"
                self.finalMean.text = "\(lroundf(responseData["final_mean"].floatValue / 60.0)) minutes"
            }
            self.tableView.reloadData()
            SwiftSpinner.hide();
        }
    }
    
    func secsToMinsConversion(seconds: Float) -> String {
        return String(format: "%.2f", seconds / 60.0)
    }
    
    func minsToSecsConversion(minutes: String) -> String {
        let secs = Float(minutes)! * 60.0
        return "\(secs)"
    }
    
    func excludeZeroWaitingTimeWeights(weightLbl: UITextField, meanVal: Float, weightVal: Int) -> UITextField {
        let uiLabel = weightLbl
        if meanVal > 0 {
            uiLabel.text = "\(weightVal)"
            uiLabel.isEnabled = true
        }
        else {
            uiLabel.text = "0"
            uiLabel.isEnabled = false
        }
        return uiLabel
    }

}
