//
//  FQCategoriesCollectionViewController.swift
//  FeatherQ Mockup
//
//  Created by Paul Andrew Gutib on 11/10/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FQCategoriesCollectionViewCell"

class FQCategoriesCollectionViewController: UICollectionViewController {
    
    var categoryList = [
        ["name": "Agriculture", "image": "CatAgriculture"],
        ["name": "Energy", "image": "CatEnergy"],
        ["name": "Mining and Quarrying", "image": "CatMining"],
        ["name": "Manufacturing", "image": "CatManufacturing"],
        ["name": "Government", "image": "CatGovernment"],
        ["name": "Construction", "image": "CatConstruction"],
        ["name": "Wholesale and Retail", "image": "CatRetail"],
        ["name": "Hotels and Restaurants", "image": "CatHotel"],
        ["name": "Transportation", "image": "CatTransportation"],
        ["name": "Telecommunications", "image": "CatTelecommunications"],
        ["name": "Financial", "image": "CatFinancial"],
        ["name": "Education", "image": "CatEducation"],
        ["name": "Social Services", "image": "CatSocial"],
        ["name": "Health Care", "image": "CatHealth"],
        ["name": "Technology", "image": "CatTechnology"],
        ["name": "Entertainment", "image": "CatEntertainment"],
        ["name": "Mass Media", "image": "CatMedia"],
        ["name": "All", "image": "AboutLogo"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(FQCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
//        Alamofire.request(Router.getCategories).responseJSON { response in
//            if response.result.isFailure {
//                debugPrint(response.result.error!)
//                let errorMessage = (response.result.error?.localizedDescription)! as String
//                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
//                    SwiftSpinner.hide()
//                })
//                return
//            }
//            let responseData = JSON(data: response.data!)
//            debugPrint(responseData)
//            for categories in responseData["categories"] {
//                let dataObj = categories.1.dictionaryObject!
//                self.categoryList.append(dataObj["industry"] as! String)
//            }
//            self.collectionView?.reloadData()
//            SwiftSpinner.hide()
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "filterByCategory" {
            let destView = segue.destination as! FQSearchTableViewController
            if let selectedCell = sender as? FQCategoriesCollectionViewCell {
                destView.chosenCategory = selectedCell.categoryTitle.text!
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.categoryList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FQCategoriesCollectionViewCell
    
        // Configure the cell
        cell.categoryTitle.text = self.categoryList[indexPath.row]["name"]
        cell.categoryBackground.image = UIImage(named: self.categoryList[indexPath.row]["image"]!)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let squareSize = (UIScreen.main.bounds.width / 3.0) - 3.0
        return CGSize(width: squareSize, height: squareSize)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
