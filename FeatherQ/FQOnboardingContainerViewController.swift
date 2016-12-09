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
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startServingBtn.layer.cornerRadius = 5.0
        self.startServingBtn.clipsToBounds = true
        self.pageTitles = NSArray(objects: "Intro1", "Intro3", "Intro2")
        self.pageImages = NSArray(objects: "Intro1", "Intro3", "Intro2")
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FQOnboardingPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as FQOnboardingContentViewController
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as! [FQOnboardingContentViewController], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height + 40)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
//        self.view.bringSubviewToFront(self.logoTitle)
//        self.view.bringSubviewToFront(self.swipeIndex)
//        self.view.bringSubviewToFront(self.subTitle)
//        self.view.bringSubviewToFront(self.subDesc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQOnboardingContentViewController
        var index = vc.pageIndex as Int
        index += 1
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
        if (index == 0 || index == NSNotFound) {
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
    
    

}
