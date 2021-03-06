//
//  FQSearchTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 11/23/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftSpinner
import CoreLocation

class FQSearchTableViewController: UITableViewController, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    @IBOutlet weak var enableLocationBtn: UIBarButtonItem!
    
    var filterSearch = UISearchController()
    var businessList = [FQBusiness]()
    var filteredBusinesses = [String]()
    var cllManager = CLLocationManager()
    var latitudeLoc: String?
    var longitudeLoc: String?
    var recurseIfEmpty = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        SwiftSpinner.show("Preparing..")
        self.filterSearch = UISearchController(searchResultsController: nil)
        self.filterSearch.searchResultsUpdater = self
        self.filterSearch.dimsBackgroundDuringPresentation = false
        self.filterSearch.searchBar.sizeToFit()
        self.filterSearch.searchBar.placeholder = "Name, address, category, business code.."
        self.refreshControl?.addTarget(self, action: #selector(FQSearchTableViewController.refresherOrb(_:)), for: .valueChanged)
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = self.filterSearch.searchBar
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "fqiosappfreelocation") == "granted" {
            self.navigationItem.rightBarButtonItem = nil
            self.cllManager.delegate = self
            self.cllManager.desiredAccuracy = kCLLocationAccuracyBest
            self.cllManager.requestWhenInUseAuthorization()
            self.cllManager.startUpdatingLocation()
        }
        else {
            self.postDisplayBusinesses()
        }
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
        let listData = self.businessListingDetails(indexPath.row)
        cell.businessName.text = listData["name"]
        cell.categoryName.text = listData["category"]
        cell.address.text = listData["address"]
        cell.peopleInLine.text = listData["people_in_line"]
        cell.waitingTIme.text = listData["serving_time"]
        cell.keyLabel.text = listData["key"]
        if !listData["logo"]!.isEmpty {
            let url = URL(string: "https://ucarecdn.com/" + listData["logo"]! + "/image")
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                DispatchQueue.main.async {
//                    cell.businessLogo.image = UIImage(data: data!)
//                }
//            }
            cell.businessLogo.af_setImage(withURL: url!, placeholderImage: UIImage(named: "PlaceholderLogo"))
//            cell.businessLogo.image = cell.businessLogo.image!.af_imageRounded(withCornerRadius: 10.0)
        }
        else {
            cell.businessLogo.image = UIImage(named: "PlaceholderLogo")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245.0
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
    open func updateSearchResults(for searchController: UISearchController) {
        var unwrappedBusinessNames = [String]()
        for business in self.businessList {
            let part1 = business.name!+"|"+business.category!+"|"+business.address!+"|"+"\(business.people_in_line!)"
            let part2 = "\(business.serving_time!)"+"|"+business.key!+"|"+business.business_id!+"|"+business.time_close!
            let part3 = business.time_open!+"|"+business.logo!
            unwrappedBusinessNames.append(part1+"|"+part2+"|"+part3)
        }
        self.filteredBusinesses.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (unwrappedBusinessNames as NSArray).filtered(using: searchPredicate)
        self.filteredBusinesses = array as! [String]
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        self.latitudeLoc = "\(userLocation.coordinate.latitude)"
        self.longitudeLoc = "\(userLocation.coordinate.longitude)"
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            self.postSearchBusiness()
        })
        self.cllManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationApprovalCallback()
            debugPrint("granted when in use")
        case .denied:
            let preferences = UserDefaults.standard
            preferences.set("denied", forKey: "fqiosappfreelocation")
            preferences.synchronize()
            debugPrint("denied must change")
        default:
            let preferences = UserDefaults.standard
            preferences.set("denied", forKey: "fqiosappfreelocation")
            preferences.synchronize()
            debugPrint("denied must change")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewPublicBroadcast" {
            let destView = segue.destination as! FQSearchBroadcastViewController
            if let selectedCell = sender as? FQSearchTableViewCell {
                let indexPath = self.tableView.indexPath(for: selectedCell)!
                if self.filterSearch.isActive {
                    let businessData = self.filteredBusinesses[indexPath.row].components(separatedBy: "|")
                    destView.selectedBusiness = FQBusiness(modelAttr: [
                        "name": businessData[0],
                        "category": businessData[1],
                        "address": businessData[2],
                        "people_in_line": Int(businessData[3])!,
                        "serving_time": Int(businessData[4])!,
                        "key": businessData[5],
                        "business_id": businessData[6],
                        "time_close": businessData[7],
                        "time_open": businessData[8],
                        "logo": businessData[9],
                    ])
                    self.filterSearch.isActive = false
                }
                else {
                    destView.selectedBusiness = self.businessList[indexPath.row]
                }
            }
        }
    }
    
    @IBAction func allowLocating(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.string(forKey: "fqiosappfreelocation") == "denied" {
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
        }
        else {
            self.cllManager.delegate = self
            self.cllManager.desiredAccuracy = kCLLocationAccuracyBest
            self.cllManager.requestWhenInUseAuthorization()
            self.cllManager.startUpdatingLocation()
        }
    }
    
    func postDisplayBusinesses() {
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
                if !Session.instance.selectedCategories.isEmpty {
                    for chosenCategory in Session.instance.selectedCategories {
                        if dataObj["category"] as! String == chosenCategory {
                            self.businessList.append(FQBusiness(modelAttr: dataObj))
                        }
                    }
                }
                else {
                    self.businessList.append(FQBusiness(modelAttr: dataObj))
                }
            }
            self.tableView.reloadData()
            self.showOnboardingIfNew()
            SwiftSpinner.hide()
        }
    }
    
    func postSearchBusiness() {
        Alamofire.request(Router.postSearchBusiness(latitude: self.latitudeLoc!, longitude: self.longitudeLoc!)).responseJSON { response in
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
                self.businessList.removeAll()
                for business in responseData {
                    let dataObj = business.1.dictionaryObject!
                    if !Session.instance.selectedCategories.isEmpty {
                        for chosenCategory in Session.instance.selectedCategories {
                            if dataObj["category"] as! String == chosenCategory {
                                self.businessList.append(FQBusiness(modelAttr: dataObj))
                            }
                        }
                    }
                    else {
                        self.businessList.append(FQBusiness(modelAttr: dataObj))
                    }
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func businessListingDetails(_ index: Int) -> [String:String] {
        var listData = [String:String]()
        if self.filterSearch.isActive {
            let businessData = self.filteredBusinesses[index].components(separatedBy: "|")
            var finalAddress = businessData[2]
            let firstChar = businessData[2].characters.first
            if firstChar == "," {
                finalAddress = String(finalAddress.characters.dropFirst()) // drop 2 characters because ", "
                finalAddress = String(finalAddress.characters.dropFirst()) // drop 2 characters because ", "
            }
            listData["name"] = businessData[0]
            listData["category"] = businessData[1]
            listData["address"] = finalAddress
            listData["people_in_line"] = self.peopleInLineChecker(arg0: Int(businessData[3])!)
            listData["serving_time"] = self.convertServingTime(timeArg: Int(businessData[4])!, peopleArg: Int(businessData[3])!)
            listData["key"] = businessData[5]
            listData["logo"] = businessData[9]
        }
        else {
            var finalAddress = self.businessList[index].address!
            let firstChar = self.businessList[index].address!.characters.first
            if firstChar == "," {
                finalAddress = String(finalAddress.characters.dropFirst()) // drop 2 characters because ", "
                finalAddress = String(finalAddress.characters.dropFirst()) // drop 2 characters because ", "
            }
            listData["name"] = self.businessList[index].name!
            listData["category"] = self.businessList[index].category!
            listData["address"] = finalAddress
            listData["people_in_line"] = self.peopleInLineChecker(arg0: self.businessList[index].people_in_line!)
            listData["serving_time"] = self.convertServingTime(timeArg: businessList[index].serving_time!, peopleArg: self.businessList[index].people_in_line!)
            listData["key"] = self.businessList[index].key!
            listData["logo"] = self.businessList[index].logo!
        }
        return listData
    }
    
    func refresherOrb(_ refresher: UIRefreshControl) {
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
                if !Session.instance.selectedCategories.isEmpty {
                    for chosenCategory in Session.instance.selectedCategories {
                        if dataObj["category"] as! String == chosenCategory {
                            self.businessList.append(FQBusiness(modelAttr: dataObj))
                        }
                    }
                }
                else {
                    self.businessList.append(FQBusiness(modelAttr: dataObj))
                }
            }
            self.tableView.reloadData()
            refresher.endRefreshing()
        }
    }
    
    func convertServingTime(timeArg: Int, peopleArg: Int) -> String {
        let timeVal = timeArg * peopleArg
        if timeVal < 180 {
            return "less than 3 minutes"
        }
        let (h, m) = self.secondsToHoursMinutesSeconds(seconds: timeVal)
        if h > 0 {
            return "\(h) hours and \(m) minutes"
        }
        return "\(m) minutes"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func peopleInLineChecker(arg0: Int) -> String {
        if arg0 < 5 {
            return "less than 5"
        }
        return "\(arg0)"
    }
    
    func locationApprovalCallback() {
        let preferences = UserDefaults.standard
        preferences.set("granted", forKey: "fqiosappfreelocation")
        preferences.synchronize()
        self.navigationItem.rightBarButtonItem = nil
        self.cllManager.delegate = self
        self.cllManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cllManager.requestWhenInUseAuthorization()
        self.cllManager.startUpdatingLocation()
    }
    
    func showOnboardingIfNew() {
        if !UserDefaults.standard.bool(forKey: "fqiosappfreeonboard") {
            let onboardingTopLayer = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 100.0))
        onboardingTopLayer.tag = 1111
            let onboardingBottomLayer = UIView(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.height-54.0, width: UIScreen.main.bounds.width, height: 54.0))
        onboardingBottomLayer.tag = 2222
            UIApplication.shared.keyWindow?.addSubview(onboardingTopLayer)
            UIApplication.shared.keyWindow?.addSubview(onboardingBottomLayer)
            let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FQOnboardingLayerViewController")
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: false, completion: nil)
        }
    }
    
}
