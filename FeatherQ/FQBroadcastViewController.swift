//
//  FQBroadcastViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/5/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit
//import iCarousel
import Alamofire
import SwiftyJSON
import SwiftSpinner
import AVFoundation

class FQBroadcastViewController: UIViewController/*, iCarouselDataSource, iCarouselDelegate*/ {
 
    @IBOutlet weak var businessCode: UILabel!
//    @IBOutlet weak var calledNumbers: iCarousel!
    @IBOutlet weak var broadcastNumbers: UILabel!
    @IBOutlet weak var peopleInLine: UILabel!
    @IBOutlet weak var waitingTime: UILabel!
    @IBOutlet weak var lineStatus: UILabel!
    
    @IBOutlet weak var codeLayer: UIView!
    @IBOutlet weak var numberLayer: UIView!
    @IBOutlet weak var trafficLayer: UIView!
    @IBOutlet weak var codeHelp: UIView!
    @IBOutlet weak var trafficHelp: UIView!
    @IBOutlet weak var numberHelp: UIView!
    
    var calledNumbers = ""
    var timerCounter: Timer?
    var audioPlayer = AVAudioPlayer()
    let dingSound = URL(fileURLWithPath: Bundle.main.path(forResource: "doorbell_x", ofType: "wav")!)
    
    var priorityNumbers = [String]()
    var punchType: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.calledNumbers.type = .coverFlow2
        
        self.codeHelp.layer.cornerRadius = 5.0
        self.codeHelp.clipsToBounds = true
        self.codeHelp.layer.borderWidth = 2.0
        self.codeHelp.layer.borderColor = UIColor.black.cgColor
        self.trafficHelp.layer.cornerRadius = 5.0
        self.trafficHelp.clipsToBounds = true
        self.trafficHelp.layer.borderWidth = 2.0
        self.trafficHelp.layer.borderColor = UIColor.black.cgColor
        self.numberHelp.layer.cornerRadius = 5.0
        self.numberHelp.clipsToBounds = true
        self.numberHelp.layer.borderWidth = 2.0
        self.numberHelp.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timerCounter?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "fqiosappfreeonboardbusiness") {
            self.codeHelp.isHidden = false
            self.codeLayer.isHidden = true
            self.trafficHelp.isHidden = true
            self.trafficLayer.isHidden = false
            self.numberHelp.isHidden = true
            self.numberLayer.isHidden = false
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.broadcastNumbers.font = UIFont.systemFont(ofSize: 700.0)
        }
        self.navigationItem.title = Session.instance.businessName!
        self.businessCode.text = ""
        self.broadcastNumbers.text = ""
        self.peopleInLine.text = ""
        self.waitingTime.text = ""
        self.businessCode.text = Session.instance.key!.uppercased()
        Session.instance.viewedBusinessId = Session.instance.businessId
        self.readyDingSound()
        Alamofire.request(Router.getBusinessBroadcast(business_id: Session.instance.businessId)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error!)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    self.navigationController!.popViewController(animated: true)
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            if responseData != nil {
                self.peopleInLine.text = self.peopleInLineChecker(arg0: responseData["broadcast_data"]["people_in_line"].intValue)
                self.waitingTime.text = self.convertServingTime(timeArg: responseData["broadcast_data"]["serving_time"].intValue)
                self.priorityNumbers.removeAll()
                for callNums in responseData["broadcast_data"]["called_numbers"] {
                    let dataObj = callNums.1.dictionaryObject!
                    let pNum = dataObj["priority_number"] as! String
                    self.priorityNumbers.append(pNum)
                }
                Session.instance.broadcastNumbers = self.priorityNumbers
                self.punchType = responseData["broadcast_data"]["punch_type"].stringValue
                Session.instance.punchType = self.punchType!
                self.audioPlayer.play()
//                self.calledNumbers.reloadData()
                self.generateBroadcastNumbers()
                self.generateLineStatusDisplay()
                if self.priorityNumbers.isEmpty {
                    self.broadcastNumbers.text = responseData["broadcast_data"]["last_called"].stringValue
                }
            }
        }
        self.timerCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallbacks), userInfo: nil, repeats: true)
    }
    
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return self.priorityNumbers.count
//    }
//    
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        var label: UILabel
//        var itemView: UIImageView
//        
//        //reuse view if available, otherwise create a new view
//        if let view = view as? UIImageView {
//            itemView = view
//            //get a reference to the label in the recycled view
//            label = itemView.viewWithTag(1) as! UILabel
//        } else {
//            //don't do anything specific to the index within
//            //this `if ... else` statement because the view will be
//            //recycled and used with other index values later
//            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//            itemView.image = UIImage(named: "")
//            itemView.contentMode = .center
//            
//            label = UILabel(frame: itemView.bounds)
//            label.backgroundColor = .clear
//            label.textAlignment = .center
//            label.font = UIFont.systemFont(ofSize: 400)
//            label.adjustsFontSizeToFitWidth = true
//            label.lineBreakMode = .byClipping
//            label.numberOfLines = 0
//            label.textColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
//            label.tag = 1
//            itemView.addSubview(label)
//        }
//        
//        //set item label
//        //remember to always set any properties of your carousel item
//        //views outside of the `if (view == nil) {...}` check otherwise
//        //you'll get weird issues with carousel item content appearing
//        //in the wrong place in the carousel
//        label.text = self.priorityNumbers[index]
//        
//        return itemView
//    }
//    
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if (option == .spacing) {
//            return value * 2.0
//        }
//        return value
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func codeTap(_ sender: UITapGestureRecognizer) {
        self.codeHelp.isHidden = true
        self.codeLayer.isHidden = false
        self.trafficHelp.isHidden = false
        self.trafficLayer.isHidden = true
        self.numberHelp.isHidden = true
        self.numberLayer.isHidden = false
    }
    
    @IBAction func trafficTap(_ sender: UITapGestureRecognizer) {
        self.codeHelp.isHidden = true
        self.codeLayer.isHidden = false
        self.trafficHelp.isHidden = true
        self.trafficLayer.isHidden = false
        self.numberHelp.isHidden = false
        self.numberLayer.isHidden = true
    }
    
    @IBAction func numberTap(_ sender: UITapGestureRecognizer) {
        let alertBox = UIAlertController(title: "COMPLETE", message: "You will now be redirected back to your dashboard.", preferredStyle: .alert)
        alertBox.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
            let preferences = UserDefaults.standard
            preferences.set(true, forKey: "fqiosappfreeonboardbusiness")
            preferences.synchronize()
            let tabBarController = self.view.window?.rootViewController as! UITabBarController
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "myBusinessDashboard")
            var rootViewControllers = tabBarController.viewControllers
            rootViewControllers?[2] = vc
            vc.tabBarItem = UITabBarItem(title: "My Business", image: UIImage(named: "My Business"), tag: 2)
            tabBarController.setViewControllers(rootViewControllers, animated: false)
            tabBarController.selectedIndex = 2
        }))
        self.present(alertBox, animated: true, completion: nil)
    }
    
    
    func timerCallbacks() {
        if Session.instance.broadcastNumbers != self.priorityNumbers {
            self.audioPlayer.play()
            self.priorityNumbers = Session.instance.broadcastNumbers
//            self.calledNumbers.reloadData()
            self.generateBroadcastNumbers()
            self.peopleInLine.text = Session.instance.peopleInLine!
            self.waitingTime.text = Session.instance.servingTime!
            if Session.instance.broadcastNumbers.isEmpty {
                self.broadcastNumbers.text = Session.instance.lastCalled!
            }
        }
        if Session.instance.punchType != self.punchType! {
            self.audioPlayer.play()
            self.punchType = Session.instance.punchType
            self.generateLineStatusDisplay()
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
    
    func generateLineStatusDisplay() {
        self.lineStatus.text = self.setLineStatusText(punchType: self.punchType!)
        self.lineStatus.backgroundColor = self.setLineStatusColor(punchType: self.punchType!)
        self.lineStatus.textColor = self.setLineStatusTextColor(punchType: self.punchType!)
    }
    
    func generateBroadcastNumbers() {
        self.calledNumbers = ""
        for pNum in self.priorityNumbers {
            self.calledNumbers += pNum + "      "
        }
        self.broadcastNumbers.text = self.calledNumbers
    }
    
    func setLineStatusText(punchType: String) -> String {
        if punchType == "Play" {
            return "OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          OPEN          "
        }
        else if punchType == "Pause" {
            return "ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          ON BREAK          "
        }
        return "CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          CLOSED          "
    }
    
    func setLineStatusColor(punchType: String) -> UIColor {
        if punchType == "Play" {
            return UIColor(red: 0.2275, green: 0.549, blue: 0.0902, alpha: 1.0) /* #3a8c17 */
        }
        else if punchType == "Pause" {
            return UIColor.yellow
        }
        return UIColor(red: 0.9725, green: 0.298, blue: 0.0157, alpha: 1.0) /* #f84c04 */
    }
    
    func setLineStatusTextColor(punchType: String) -> UIColor {
        if punchType == "Pause" {
            return UIColor.black
        }
        return UIColor.white
    }
    
    func convertServingTime(timeArg: Int) -> String {
        let (h, m) = self.secondsToHoursMinutesSeconds(seconds: timeArg)
        if m < 3 {
            return "less than 3 minutes"
        }
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

}
