//
//  ChallengesViewController.swift
//  Compound
//
//  Created by Daniel Maness on 3/29/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class ChallengesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
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
        
        let uiView = self.view as UIView
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
        currentUser.getChallengesReceived({ (result, error) -> Void in
            if error == nil {
                self.challenges = result
                //self.challenges.sort({ $0.status.rawValue < $1.status.rawValue })
            } else {
                println("Error fetching challenges: " + error!.description)
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
        let title = self.challenges[indexPath.row].parentChallenge.user.displayName
        let image = self.challenges[indexPath.row].parentChallenge.user.profilePicture
        
        cell.title.text = title
        
        if image != nil {
            cell.picture.contentMode = .ScaleAspectFit
            cell.picture.image = image
            self.formatImageAsCircle(cell.picture)
        }
        
        if self.challenges[indexPath.row].status == Status.Complete {
            cell.userInteractionEnabled = false
            cell.textLabel?.alpha = 0.5
            cell.imageView?.alpha = 0.5
        } else {
            cell.userInteractionEnabled = true
            cell.textLabel?.alpha = 1.0
            cell.imageView?.alpha = 1.0
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.challenges[indexPath.row].status == Status.Incomplete {
            // This method is good for showing a view we won't need to return from
            var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("PuzzleViewController") as! PuzzleViewController
            viewController.challenge = challenges[indexPath.row]
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
}