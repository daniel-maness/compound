//
//  HomeViewController.swift
//  Compound
//
//  Created by Daniel Maness on 03/28/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    /* Actions */
    @IBAction func onPlayPressed(sender: UIButton) {
        var viewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}