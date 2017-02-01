//
//  FQOnboardingContainerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 12/9/16.
//  Copyright © 2016 Reminisense. All rights reserved.
//

import UIKit

class FQOnboardingContainerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var startQueuingBtn: UIButton!
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var pageCtrlCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.pageTitles = NSArray(objects: "Onboarding1", "Onboarding2", "Onboarding3", "Onboarding4", "Onboarding5")
//        self.pageImages = NSArray(objects: "Onboarding1", "Onboarding2", "Onboarding3", "Onboarding4", "Onboarding5")
        self.startQueuingBtn.layer.cornerRadius = 5.0
        self.startQueuingBtn.clipsToBounds = true
        self.pageTitles = NSArray(objects: "EndUserOnboarding1", "EndUserOnboarding2", "EndUserOnboarding3")
        self.pageImages = NSArray(objects: "EndUserOnboarding1", "EndUserOnboarding2", "EndUserOnboarding3")
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FQOnboardingPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let startVC = self.viewControllerAtIndex(0) as FQOnboardingContentViewController
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as! [FQOnboardingContentViewController], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height + 40)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.navigationItem.title = "Welcome"
        self.pageCtrl.numberOfPages = self.pageImages.count
        self.view.bringSubview(toFront: self.pageCtrl)
        self.view.bringSubview(toFront: self.startQueuingBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQOnboardingContentViewController
        var index = vc.pageIndex as Int
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQOnboardingContentViewController
        var index = vc.pageIndex as Int
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == self.pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let vc = pendingViewControllers[0] as! FQOnboardingContentViewController
        self.pageCtrlCount = vc.pageIndex as Int
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.pageCtrl.currentPage = self.pageCtrlCount
        }
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
        debugPrint(index)
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
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "startMainApp")
    }
}
