//
//  HomeViewController.swift
//  Compound
//
//  Created by Daniel Maness on 03/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: BaseViewController {
    /* Actions */
    @IBAction func onPlayPressed(sender: UIButton) {
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleViewController") as! PuzzleViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    @IBAction func onChallengesPressed(sender: UIButton) {
        var viewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewControllerWithIdentifier("ChallengesViewController") as! ChallengesViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onProfilePressed(sender: UIButton) {
        var viewController = UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onSettingsPressed(sender: UIButton) {
        var viewController = UIStoryboard(name: "User", bundle: nil).instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {

    }
}