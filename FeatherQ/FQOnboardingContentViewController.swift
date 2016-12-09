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
    var imageFile: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: self.imageFile)
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

}
