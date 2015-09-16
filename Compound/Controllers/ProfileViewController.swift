//
//  ProfileViewController.swift
//  Compound
//
//  Created by Daniel Maness on 4/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: BaseViewController {
    private let userManager = UserManager()
    
    /* Properties */
    let userService = UserService()
    var totalStars: String = ""
    var totalPuzzles: String = ""
    var averageStars: String = ""
    
    /* Outlets */
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var totalPuzzlesLabel: UILabel!
    @IBOutlet weak var averageStarsLabel: UILabel!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onSharePressed(sender: UIButton) {
        
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserStats()
        setupView()
        //userService.findFriends()
    }
    
    func setupView() {
        shareButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.setUserPicture(profilePicture)
        totalStarsLabel.text = totalStars
        totalPuzzlesLabel.text = totalPuzzles
        averageStarsLabel.text = averageStars
    }
    
    /* Logic */
    func getUserStats() {
        let stats = userManager.getStats()
        
        totalStars = String(stats.totalStarsEarned)
        totalPuzzles = String(stats.totalPuzzlesPlayed)
        averageStars = String(format:"%.1f", stats.averageStars)
    }
}