//
//  BaseViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    enum ViewControllerType {
        case HomeView, GameView, ChallengesView, SettingsView, ProfileView
    }
    
    convenience init() {
        self.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func switchView(viewControllerType: ViewControllerType) {
        var vc: UIViewController!
        
        switch viewControllerType {
        case .HomeView:
            vc = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        case .GameView:
            vc = storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        case .ChallengesView:
            vc = storyboard?.instantiateViewControllerWithIdentifier("ChallengesViewController") as! ChallengesViewController
        default:
            break
        }
        
        if vc != nil {
            self.view?.window?.makeKeyAndVisible()
            self.view?.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
