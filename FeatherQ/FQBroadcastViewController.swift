//
//  FQBroadcastViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/5/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import iCarousel

class FQBroadcastViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var businessCode: UILabel!
    @IBOutlet weak var calledNumbers: iCarousel!
    
    var priorityNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 123, 123, 888]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.calledNumbers.type = .coverFlow2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.priorityNumbers.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .center
            
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 400)
            label.adjustsFontSizeToFitWidth = true
            label.lineBreakMode = .byClipping
            label.numberOfLines = 0
            label.textColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
            label.tag = 1
            itemView.addSubview(label)
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(self.priorityNumbers[index])"
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
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
