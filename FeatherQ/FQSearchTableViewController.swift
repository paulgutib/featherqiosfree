//
//  FQSearchTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filterSearch = UISearchController()
    var businessList = [FQBusiness]()
    var filteredBusinesses = [String]()
    var chosenCategory = "All"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.filterSearch = UISearchController(searchResultsController: nil)
        self.filterSearch.searchResultsUpdater = self
        self.filterSearch.dimsBackgroundDuringPresentation = false
        self.filterSearch.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.filterSearch.searchBar
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postDisplayBusinesses()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.filterSearch.isActive {
            return self.filteredBusinesses.count
        }
        return self.businessList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FQSearchTableViewCell", for: indexPath) as! FQSearchTableViewCell

        // Configure the cell...
        let listData = self.businessListingDetails(index: indexPath.row)
        cell.businessName.text = listData["name"]
        cell.categoryName.text = listData["category"]
        cell.address.text = listData["address"]
        cell.peopleInLine.text = listData["people_in_line"]
        cell.waitingTIme.text = listData["serving_time"]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.filterSearch.isActive = false
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
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        var unwrappedBusinessNames = [String]()
        for business in self.businessList {
            unwrappedBusinessNames.append(business.name!+"|"+business.category!+"|"+business.address!+"|"+business.people_in_line!+"|"+business.serving_time!+"|"+business.key!)
        }
        self.filteredBusinesses.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (unwrappedBusinessNames as NSArray).filtered(using: searchPredicate)
        self.filteredBusinesses = array as! [String]
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func postDisplayBusinesses() {
        SwiftSpinner.show("Fetching..")
        Alamofire.request(Router.postDisplayBusinesses).responseJSON { response in
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
            self.businessList.removeAll()
            for business in responseData {
                let dataObj = business.1.dictionaryObject!
                if self.chosenCategory != "All" {
                    if dataObj["category"] as! String == self.chosenCategory {
                        self.businessList.append(FQBusiness(modelAttr: dataObj))
                    }
                }
                else {
                    self.businessList.append(FQBusiness(modelAttr: dataObj))
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func businessListingDetails(index: Int) -> [String:String] {
        var listData = [String:String]()
        if self.filterSearch.isActive {
            let businessData = self.filteredBusinesses[index].components(separatedBy: "|")
            listData["name"] = businessData[0]
            listData["category"] = businessData[1]
            listData["address"] = businessData[2]
            listData["people_in_line"] = businessData[3]
            listData["serving_time"] = businessData[4]
        }
        else {
            listData["name"] = self.businessList[index].name!
            listData["category"] = self.businessList[index].category!
            listData["address"] = self.businessList[index].address!
            listData["people_in_line"] = self.businessList[index].people_in_line!
            listData["serving_time"] = self.businessList[index].serving_time!
        }
        return listData
    }
    
}
