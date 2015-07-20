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
    @IBOutlet weak var profilePicture: UIImageView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
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
        
        self.setUserPicture(profilePicture)
    }
}