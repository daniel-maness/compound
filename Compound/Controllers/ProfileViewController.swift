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
    /* Properties */
    let userDA = UserDA()
    var totalStars: String = ""
    var totalPuzzles: String = ""
    var totalWon: String = ""
    var totalLost: String = ""
    var averageStars: String = ""
    var totalHints: String = ""
    var averageTime: String = ""
    var vsTotalWon: String = ""
    var vsTotalLost: String = ""
    var vsTotalHints: String = ""
    var vsAverageTime: String = ""
    var bestAverageStars: String = ""
    var bestAverageRank: String = ""
    var bestAverageTime: String = ""
    
    /* Outlets */
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var totalWonLabel: UILabel!
    @IBOutlet weak var totalLostLabel: UILabel!
    @IBOutlet weak var averageStarsLabel: UILabel!
    @IBOutlet weak var totalHintsLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var vsTotalWonLabel: UILabel!
    @IBOutlet weak var vsTotalLostLabel: UILabel!
    @IBOutlet weak var vsTotalHintsLabel: UILabel!
    @IBOutlet weak var vsAverageTimeLabel: UILabel!
    @IBOutlet weak var bestAverageStarsLabel: UILabel!
    @IBOutlet weak var bestAverageRankLabel: UILabel!
    @IBOutlet weak var bestAverageTimeLabel: UILabel!
    
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
    }
    
    func setupView() {
        shareButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.setUserPicture(profilePicture)
        totalStarsLabel.text = totalStars
        totalWonLabel.text = totalWon
        totalLostLabel.text = totalLost
        averageStarsLabel.text = averageStars
        totalHintsLabel.text = totalHints
        averageTimeLabel.text = averageTime
        vsTotalWonLabel.text = vsTotalWon
        vsTotalLostLabel.text = vsTotalLost
        vsTotalHintsLabel.text = vsTotalHints
        vsAverageTimeLabel.text = vsAverageTime
        bestAverageStarsLabel.text = bestAverageStars
        bestAverageRankLabel.text = bestAverageRank
        bestAverageTimeLabel.text = bestAverageTime
    }
    
    /* Logic */
    func getUserStats() {
        let stats = currentUser.getStats()
        
        totalStars = String(stats.totalStarsEarned)
        totalPuzzles = String(stats.totalPuzzlesPlayed)
        totalWon = String(stats.totalPuzzlesCompleted)
        totalLost = String(stats.totalPuzzlesGaveUp + stats.totalPuzzlesTimeUp)
        averageStars = String(format:"%.1f", stats.averageStars)
        totalHints = String(stats.totalHintsUsed)
        
        if stats.averageTime == 60 {
            averageTime = "1:00"
        } else if stats.averageTime > 9 {
            averageTime = "0:" + String(stats.averageTime)
        } else {
            averageTime = "0:0" + String(stats.averageTime)
        }
        
        //let versusStats = userDA.getVersusStats()
        
        //let bestOfStats = userDA.getBestOfStats()
    }
}