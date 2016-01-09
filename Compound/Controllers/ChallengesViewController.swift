//
//  ChallengesViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class ChallengesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private let challengeManager = ChallengeManager()
    private let userManager = UserManager()
    
    /* Properties */
    var totalWon: String = ""
    var totalLost: String = ""
    var bestOfAverage: String = ""
    
    var challenges = [Challenge]() {
        didSet {
            refreshUI()
        }
    }
    
    /* Outlets */
    @IBOutlet weak var totalWonLabel: UILabel!
    @IBOutlet weak var totalLostLabel: UILabel!
    @IBOutlet weak var bestOfAverageLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    /* Actions */
    @IBAction func onSharePressed(sender: UIButton) {
        
    }
    
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onNewChallengePressed(sender: UIButton) {
        
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        self.setUserPicture(profilePicture)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        populateStats()
        populateChallengesTable()
    }
    
    func populateStats() {
        totalWonLabel.text = totalWon
        totalLostLabel.text = totalLost
        bestOfAverageLabel.text = bestOfAverage
    }
    
    func populateChallengesTable() {
        challengeManager.getChallengesReceived({ (result, error) -> Void in
            if error == nil {
                self.challenges.appendContentsOf(result)
                //self.challenges.sort({ $0.status.rawValue < $1.status.rawValue })
            } else {
                EventService.logError(error!, description: "Challenges Received could not be fetched", object: "ChallengesViewController", function: "populateChallengesTable")
            }
        })
        
        challengeManager.getChallengesSent({ (result, error) -> Void in
            if error == nil {
                self.challenges.appendContentsOf(result)
                //self.challenges.sort({ $0.status.rawValue < $1.status.rawValue })
            } else {
                EventService.logError(error!, description: "Challenges Sent could not be fetched", object: "ChallengesViewController", function: "populateChallengesTable")
            }
        })
    }
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FriendCell = self.tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
        let title: String
        let image: UIImage
        let statusIcon: UIImage
        
        if self.challenges[indexPath.row].user.objectId == CurrentUser.objectId {
            // Received
            title = self.challenges[indexPath.row].parentChallenge.user.displayName
            image = self.challenges[indexPath.row].parentChallenge.user.profilePicture
            statusIcon = UIImage(named: "challenge-received")!
        } else {
            // Sent
            title = self.challenges[indexPath.row].user.displayName
            image = self.challenges[indexPath.row].user.profilePicture
            
            if self.challenges[indexPath.row].status == Status.Complete {
                statusIcon = UIImage(named: "challenge-results")!
            } else {
                statusIcon = UIImage(named: "challenge-in-progress")!
            }
        }
        
        cell.title.text = title
        
        cell.picture.contentMode = .ScaleAspectFit
        cell.picture.image = image
        self.formatImageAsCircle(cell.picture)
        
        cell.statusIcon.contentMode = .ScaleAspectFit
        cell.statusIcon.image = statusIcon
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challenge = self.challenges[indexPath.row]
        
        if challenge.status == Status.Complete {
            challengeManager.markChallengeInactive(challenge)
            let cell: FriendCell = self.tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
            cell.removeFromSuperview()
        }
        
        if challenge.user.objectId == CurrentUser.objectId {
            playChallenge(challenge)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            viewChallengeResults(challenge)
        }
    }
    
    func playChallenge(challenge: Challenge) {
        let viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleViewController") as! PuzzleViewController
        viewController.challenge = challenge
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func viewChallengeResults(challenge: Challenge) {
        let viewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewControllerWithIdentifier("ChallengeResultsViewController") as! ChallengeResultsViewController
        
        viewController.setAnswerView(challenge.puzzle.combinations[0].combinedWord,
            word2: challenge.puzzle.combinations[1].combinedWord,
            word3: challenge.puzzle.combinations[2].combinedWord,
            keyword: challenge.puzzle.keyword)
        
        viewController.currentStars =  challenge.puzzle.currentStars
        viewController.totalStars = userManager.getStats().totalStarsEarned
        viewController.userChallenge = challenge
        viewController.parentChallenge = challenge.parentChallenge
        
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}