//
//  FQGuidesDocumentViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 2/14/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQGuidesDocumentViewController: UIViewController {

    @IBOutlet weak var webPage: UIWebView!
    
    var urlStringRequest: String?
    var userTypeGuide: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.userTypeGuide!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.webPage.loadRequest(URLRequest(url: URL(string: Router.baseURL + "/docs/" + self.urlStringRequest!)!))
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
