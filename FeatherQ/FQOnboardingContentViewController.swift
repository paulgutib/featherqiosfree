//
//  FQOnboardingContentViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/9/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    
    var imageFile: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: self.imageFile)
        self.displaySubtitles()
//        self.indexMarker.text = "(\(self.pageIndex+1)/5)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displaySubtitles() {
        if self.pageIndex == 0 {
//            self.headerTitle.text = "Dashboard Display"
//            self.subtitle.text = "Queuing options are available in the dashboard. Checking an option makes it the default screen to show the next time the app starts."
            self.headerTitle.text = "Hate getting stuck while you wait?"
            self.subtitle.text = "FeatherQ lets you stay in line without standing in line!"
        }
        else if self.pageIndex == 1 {
//            self.headerTitle.text = "Issuing a Number"
//            self.subtitle.text = "Choose a number you want to issue and put in notes if necessary."
            self.headerTitle.text = "Location and Line Status"
            self.subtitle.text = "Find businesses near you and see what numbers are being called."
        }
        else if self.pageIndex == 2 {
            self.headerTitle.text = "Wait Comfortably"
            self.subtitle.text = "FeatherQ lets you shop, dine and explore while waiting for your turn."

        }
//        else if self.pageIndex == 3 {
//            self.headerTitle.text = "Serve or Drop"
//            self.subtitle.text = "Serving or dropping a number is enabled once it has been called. Swiping from left to right serves the current number and calls the next one."
//        }
//        else if self.pageIndex == 4 {
//            self.headerTitle.text = "Broadcast Publicly"
//            self.subtitle.text = "Display this screen in a visible area of your establishment for waiting customers to see the progress of the line."
//        }
//        else if self.pageIndex == 5 {
//            self.subtitle.text = "You can review this guide in the \"Help (?)\" section of the app.\n\n\n"
//        }
    }

}
