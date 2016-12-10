//
//  FQOnboardingContainerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/9/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var startServingBtn: UIButton!
    @IBOutlet weak var fqLogo: UIImageView!
    @IBOutlet weak var whiteLogo: UIImageView!
    @IBOutlet weak var logoBackground: UIImageView!
    @IBOutlet weak var prevBtn: UIImageView!
    @IBOutlet weak var nextBtn: UIImageView!
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startServingBtn.layer.cornerRadius = 5.0
        self.startServingBtn.clipsToBounds = true
        self.pageTitles = NSArray(objects: "Onboarding1", "Onboarding2", "Onboarding3", "Onboarding4", "Onboarding5", "Onboarding6")
        self.pageImages = NSArray(objects: "Onboarding1", "Onboarding2", "Onboarding3", "Onboarding4", "Onboarding5", "Onboarding6")
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FQOnboardingPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as FQOnboardingContentViewController
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as! [FQOnboardingContentViewController], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height + 40)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.view.bringSubview(toFront: self.logoBackground)
        self.view.bringSubview(toFront: self.fqLogo)
        self.view.bringSubview(toFront: self.whiteLogo)
        self.view.bringSubview(toFront: self.prevBtn)
        self.prevBtn.isHidden = true
        self.view.bringSubview(toFront: self.nextBtn)
        self.startServingBtn.isHidden = true
        self.view.bringSubview(toFront: self.startServingBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQOnboardingContentViewController
        var index = vc.pageIndex as Int
        index += 1
        if index == self.pageTitles.count - 1 {
            self.startServingBtn.isHidden = false
            self.nextBtn.isHidden = true
        }
        self.prevBtn.isHidden = false
        if (index == NSNotFound || index == self.pageTitles.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQOnboardingContentViewController
        var index = vc.pageIndex as Int
        self.startServingBtn.isHidden = true
        self.nextBtn.isHidden = false
        if (index == 0 || index == NSNotFound) {
            self.prevBtn.isHidden = true
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func viewControllerAtIndex(_ index: Int) -> FQOnboardingContentViewController {
        let vc: FQOnboardingContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FQOnboardingContentViewController") as! FQOnboardingContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        return vc
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func startServing(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "startMainApp")
        self.present(vc, animated: true, completion: nil)
    }
    

}
