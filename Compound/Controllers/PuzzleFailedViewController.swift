//
//  PuzzleFailedViewController.swift
//  Compound
//
//  Created by Daniel Maness on 4/22/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class PuzzleFailedViewController: BaseViewController {
    /* Properties */
    var message: String = ""
    var totalStars: Int = 0
    
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiView = self.view as UIView
        setupView()
    }
    
    func setupView() {
        messageLabel.text = self.message
        totalStarsLabel.text = String(self.totalStars)
    }
}