//
//  ChallengePuzzleViewController.swift
//  Compound
//
//  Created by Daniel Maness on 5/4/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class ChallengePuzzleViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    /* Properties */
    var word0: NSMutableAttributedString!
    var word1: NSMutableAttributedString!
    var word2: NSMutableAttributedString!
    var totalStars: Int = 0
    var friendsList: [Friend]!
    var selectedFriends: [Int?] = []
    var selectedCount = 0
    var userPuzzleId: Int = 0
    let challengeDA = ChallengeDA()
    
    /* Outlets */
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onChallengePressed(sender: UIButton) {
        var friendIds = [Int]()
        for selected in selectedFriends {
            if selected != nil {
                friendIds.append(selected!)
            }
        }
        
        challengeDA.sendChallenge(self.userPuzzleId, friendIds: friendIds, challengeTime: DateTime.now())
        self.view.removeFromSuperview()
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
        
        challengeButton.enabled = false
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        populateFriendsTable()
    }
    
    func populateFriendsTable() {
        friendsList = currentUser.getFriendsList()
        
        for i in 0..<friendsList.count {
            self.selectedFriends.append(nil)
        }
        
        self.selectedCount = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.imageView?.image = UIImage(named: self.friendsList[indexPath.row].pictureFileName)
        cell.textLabel?.text = self.friendsList[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let id = self.friendsList[indexPath.row].id
        self.selectedFriends[index] = id
        selectedCount++
        toggleChallengeButton()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let id = self.friendsList[indexPath.row].id
        self.selectedFriends[index] = nil
        selectedCount--
        toggleChallengeButton()
    }
    
    func toggleChallengeButton() {
        challengeButton.enabled = selectedCount > 0 ? true : false
    }
}