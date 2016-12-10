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
    
    var imageFile: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: self.imageFile)
        self.displaySubtitles()
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
            self.subtitle.text = "Go to \"My Business\" and follow on-screen instructions to register your business for free.\nAfter registration, you will be redirected to your dashboard where you can choose your line processing.\nYou can also set what process you are using frequently to make it as default on the next time you start the app."
        }
        else if self.pageIndex == 1 {
            self.subtitle.text = "You can issue a number specifically along with an annotation to your clients.\nThere is also a time estimation for when each issued number might be called.\nAfter issuing a number, a popup will show along with its confirmation code for reference."
        }
        else if self.pageIndex == 2 {
            self.subtitle.text = "You will be given an option to serve or drop a number after calling it.\nReference information such as the time the number was issued, the annotations attached to it, and its confirmation code will be shown in this view."
        }
        else if self.pageIndex == 3 {
            self.subtitle.text = "For faster transactions, you can full swipe to either left or right to serve the current number and automatically call the next one."
        }
        else if self.pageIndex == 4 {
            self.subtitle.text = "All called numbers will be shown on the broadcast screen.\nAlso shown in the broadcast screen is the unique 4-character key that can be used to search your business faster."
        }
        else if self.pageIndex == 5 {
            self.subtitle.text = "You can review this guide in the \"Help (?)\" section of the app.\n\n\n"
        }
    }

}
