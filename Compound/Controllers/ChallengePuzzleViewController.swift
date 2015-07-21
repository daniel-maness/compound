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
    var selectedFriends: [String?] = []
    var selectedCount = 0
    var userPuzzleId: Int = 0
    let challengeDA = ChallengeDA()
    
    var friendsList = [Friend]() {
        didSet {
            refreshUI()
        }
    }
    
    /* Outlets */
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    /* Actions */
    @IBAction func onExitPressed(sender: UIButton) {
        exitView(false)
    }
    
    @IBAction func onChallengePressed(sender: UIButton) {
        var friendIds = [String]()
        for selected in selectedFriends {
            if selected != nil {
                friendIds.append(selected!)
            }
        }
        
        challengeDA.sendChallenge(self.userPuzzleId, friendIds: friendIds, challengeTime: DateTime.now())
        
        exitView(true)
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
        
        challengeButton.enabled = false
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.registerNib(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
        populateFriendsTable()
    }
    
    func populateFriendsTable() {
        Facebook.getFriends(false, completion: { (result: [Friend], error: NSError!) -> Void in
            if error == nil {
                self.friendsList = result
            } else {
                println(error)
            }
        })
    }
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FriendCell = self.tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
        let title = self.friendsList[indexPath.row].displayName
        let image = self.friendsList[indexPath.row].profilePicture
        
        cell.title.text = title
        
        if image != nil {
            cell.picture.contentMode = .ScaleAspectFit
            cell.picture.image = image
            self.formatImageAsCircle(cell.picture)
//            dispatch_async(dispatch_get_main_queue(), {
//                if let friendCell = tableView.cellForRowAtIndexPath(indexPath) as? FriendCell {
//                    friendCell.picture.image = image
//                    self.formatImageAsCircle(friendCell.picture)
//                }
//            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let id = self.friendsList[indexPath.row].id
        //self.selectedFriends[index] = String(id)
        selectedCount++
        toggleChallengeButton()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let id = self.friendsList[indexPath.row].id
        //self.selectedFriends[index] = nil
        selectedCount--
        toggleChallengeButton()
    }
    
    func toggleChallengeButton() {
        challengeButton.enabled = selectedCount > 0 ? true : false
    }
    
    func exitView(challengeSent: Bool) {
        var parent = self.parentViewController as! PuzzleCompletedViewController
        parent.challengeButton.enabled = !challengeSent
        self.view.removeFromSuperview()
    }
}