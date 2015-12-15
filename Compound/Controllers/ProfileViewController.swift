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
    var totalPuzzles: String = ""
    var averageStars: String = ""
    var versusWon: String = ""
    var versusLost: String = ""
    var bestOfWon: String = ""
    var bestOfLost: String = ""
    
    /* Outlets */
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var totalPuzzlesLabel: UILabel!
    @IBOutlet weak var averageStarsLabel: UILabel!
    @IBOutlet weak var versusWonLabel: UILabel!
    @IBOutlet weak var versusLostLabel: UILabel!
    @IBOutlet weak var bestOfWonLabel: UILabel!
    @IBOutlet weak var bestOfLostLabel: UILabel!
    
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
        self.setUserPicture(profilePicture)
        totalPuzzlesLabel.text = totalPuzzles
        averageStarsLabel.text = averageStars
        versusWonLabel.text = versusWon
        versusLostLabel.text = versusLost
        bestOfWonLabel.text = bestOfWon
        bestOfLostLabel.text = bestOfLost
    }
    
    /* Logic */
    func getUserStats() {
        let stats = userManager.getStats()
        
        totalPuzzles = String(stats.totalPuzzlesPlayed)
        averageStars = String(format:"%.1f", stats.averageStars)
        versusWon = String(0)
        versusLost = "-" + String(0)
        bestOfWon = String(0)
        bestOfLost = "-" + String(0)
    }
}