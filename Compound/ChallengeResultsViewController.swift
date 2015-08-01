//
//  ChallengeResultsViewController.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import UIKit

class ChallengeResultsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private let userManager = UserManager()
    
    /* Properties */
    var word0: NSMutableAttributedString!
    var word1: NSMutableAttributedString!
    var word2: NSMutableAttributedString!
    var currentStars: Int = 0
    var totalStars: Int = 0
    var userChallenge: Challenge!
    var parentChallenge: Challenge!
    var results = [Challenge]()
    
    /* Outlets */
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStars: UIImageView!
    @IBOutlet weak var userTime: UILabel!
    @IBOutlet weak var challengerPicture: UIImageView!
    @IBOutlet weak var challengerName: UILabel!
    @IBOutlet weak var challengerStars: UIImageView!
    @IBOutlet weak var challengerTime: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onNextPressed(sender: UIButton) {
        
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiView = self.view as UIView
        setupView()
    }
    
    func setupView() {
        word0.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12.0), range: NSMakeRange(0, word0.length))
        word1.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12.0), range: NSMakeRange(0, word1.length))
        word2.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12.0), range: NSMakeRange(0, word2.length))
        
        wordLabel0.attributedText = word0
        wordLabel1.attributedText = word1
        wordLabel2.attributedText = word2
        totalStarsLabel.text = String(totalStars)
        self.setUserPicture(profilePicture)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .None
        
        populateResultsTable()
    }
    
    func populateResultsTable() {
        if self.userChallenge.puzzle.starsEarned == self.parentChallenge.puzzle.starsEarned {
            if self.userChallenge.puzzle.time >= self.parentChallenge.puzzle.time {
                results.append(self.userChallenge)
                results.append(self.parentChallenge)
            } else {
                results.append(self.parentChallenge)
                results.append(self.userChallenge)
            }
        } else if self.userChallenge.puzzle.starsEarned > self.parentChallenge.puzzle.starsEarned {
            results.append(self.userChallenge)
            results.append(self.parentChallenge)
        } else {
            results.append(self.parentChallenge)
            results.append(self.userChallenge)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CompoundCell = self.tableView.dequeueReusableCellWithIdentifier("compoundCell", forIndexPath: indexPath) as! CompoundCell
        let profileImage = self.results[indexPath.row].user.profilePicture
        let name = self.results[indexPath.row].user.displayName
        let stars = self.results[indexPath.row].puzzle.maxStars - self.results[indexPath.row].puzzle.hintsUsed
        let time = DateTime.getFormattedSeconds(self.results[indexPath.row].puzzle.time)
        
        if indexPath.row == 0 {
            cell.trophyImage.image = UIImage(named: "trophy-flag")
        } else if indexPath.row == results.count {
            cell.trophyImage.image = UIImage(named: "trophy-shit")
        }
        
        cell.profileImage.contentMode = .ScaleAspectFit
        cell.profileImage.image = profileImage
        self.formatImageAsCircle(cell.profileImage)
        
        cell.name.text = name
        
        cell.starImage.image = UIImage(named: "star-count-" + String(stars))
        
        cell.time.text = time
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

}
