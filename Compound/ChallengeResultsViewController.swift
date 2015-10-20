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
    private let challengeManager = ChallengeManager()
    private var word1: String!
    private var word2: String!
    private var word3: String!
    private var keyword: String!
    
    /* Properties */
    var currentStars: Int = 0
    var totalStars: Int = 0
    var userChallenge: Challenge!
    var parentChallenge: Challenge!
    var results = [Challenge]()
    
    /* Outlets */
    @IBOutlet weak var totalStarsLabel: UILabel!
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
    @IBOutlet weak var answerView: AnswerView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onOkayPressed(sender: UIButton) {
        if userChallenge.status == Status.Complete {
            challengeManager.markChallengeInactive(userChallenge)
        }
        
        let viewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewControllerWithIdentifier("ChallengesViewController") as! ChallengesViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        answerView.setText(self.word1, word2: self.word2, word3: self.word3, keyword: self.keyword)
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
        let challenge = self.results[indexPath.row]
        let profileImage = challenge.user.profilePicture
        let name = challenge.user.displayName
        let stars = challenge.puzzle.maxStars - challenge.puzzle.hintsUsed
        let time = DateTime.getFormattedSeconds(challenge.puzzle.time)
        
        if indexPath.row == 0 {
            cell.trophyImage.image = UIImage(named: "trophy-flag")
        } else if indexPath.row == results.count {
            cell.trophyImage.image = UIImage(named: "trophy-shit")
        }
        
        cell.profileImage.contentMode = .ScaleAspectFit
        cell.profileImage.image = profileImage
        self.formatImageAsCircle(cell.profileImage)
        
        cell.name.text = name
        
        if challenge.status == Status.Complete {
            cell.waitingLabel.hidden = true
            cell.starImage.hidden = false
            cell.time.hidden = false
            
            cell.starImage.image = UIImage(named: "star-count-" + String(stars))
            cell.time.text = time
        } else {
            cell.waitingLabel.hidden = false
            cell.starImage.hidden = true
            cell.time.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func setAnswerView(word1: String, word2: String, word3: String, keyword: String) {
        self.word1 = word1
        self.word2 = word2
        self.word3 = word3
        self.keyword = keyword
    }
}
