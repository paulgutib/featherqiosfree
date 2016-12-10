//
//  FQBroadcastViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/5/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
import iCarousel
import Alamofire
import SwiftyJSON
import SwiftSpinner
import AVFoundation

class FQBroadcastViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var businessCode: UILabel!
    @IBOutlet weak var calledNumbers: iCarousel!
    
    var timerCounter: Timer?
    var audioPlayer = AVAudioPlayer()
    let dingSound = URL(fileURLWithPath: Bundle.main.path(forResource: "doorbell_x", ofType: "wav")!)
    
    var priorityNumbers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.calledNumbers.type = .coverFlow2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timerCounter?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Session.instance.businessName!
        self.businessCode.text = Session.instance.key!.uppercased()
        Session.instance.viewedBusinessId = Session.instance.businessId
        self.readyDingSound()
        Alamofire.request(Router.getBusinessBroadcast(business_id: Session.instance.businessId)).responseJSON { response in
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
                self.priorityNumbers.removeAll()
                for callNums in responseData["broadcast_data"]["called_numbers"] {
                    let dataObj = callNums.1.dictionaryObject!
                    let pNum = dataObj["priority_number"] as! String
                    self.priorityNumbers.append(pNum)
                }
                Session.instance.broadcastNumbers = self.priorityNumbers
                self.audioPlayer.play()
                self.calledNumbers.reloadData()
            }
        }
        self.timerCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallbacks), userInfo: nil, repeats: true)
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
        label.text = self.priorityNumbers[index]
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 2.0
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
    
    func timerCallbacks() {
        if Session.instance.broadcastNumbers != self.priorityNumbers {
            if Session.instance.playSound {
                self.audioPlayer.play()
            }
            self.priorityNumbers = Session.instance.broadcastNumbers
            self.calledNumbers.reloadData()
        }
    }
    
    func readyDingSound() {
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.dingSound as URL, fileTypeHint: nil)
            self.audioPlayer.prepareToPlay()
        }catch {
            print("Error getting the audio file")
        }
    }

}
