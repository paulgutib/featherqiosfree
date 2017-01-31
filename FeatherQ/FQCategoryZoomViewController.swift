//
//  FQCategoryZoomViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 1/31/17.
//  Copyright © 2017 Reminisense. All rights reserved.
//

import UIKit

class FQCategoryZoomViewController: UIViewController {
    
    @IBOutlet weak var zoomedImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    
    var imageFile: String?
    var categoryName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.zoomedImage.layer.cornerRadius = 5.0
        self.zoomedImage.clipsToBounds = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.catName.font = UIFont.boldSystemFont(ofSize: 70.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.zoomedImage.image = UIImage(named: self.imageFile!)
        self.catName.text = self.categoryName!
        self.catName.attributedText = NSAttributedString(string: self.categoryName!, attributes: [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -3,
            NSForegroundColorAttributeName: UIColor.white
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func closeZoom(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
