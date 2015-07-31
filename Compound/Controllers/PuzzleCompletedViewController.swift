//
//  PuzzleCompletedViewController.swift
//  Compound
//
//  Created by Daniel Maness on 4/16/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class PuzzleCompletedViewController: BaseViewController {
    private let userManager = UserManager()
    
    /* Properties */
    var word0: NSMutableAttributedString!
    var word1: NSMutableAttributedString!
    var word2: NSMutableAttributedString!
    var currentStars: Int = 0
    var totalStars: Int = 0
    var puzzle: Puzzle!
    
    /* Outlets */
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onChallengePressed(sender: UIButton) {
        // This method is good for showing a view we may need to return from
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("ChallengePuzzleViewController") as! ChallengePuzzleViewController
        viewController.word0 = wordLabel0.attributedText as! NSMutableAttributedString
        viewController.word1 = wordLabel1.attributedText as! NSMutableAttributedString
        viewController.word2 = wordLabel2.attributedText as! NSMutableAttributedString
        viewController.totalStars = userManager.getStats().totalStarsEarned
        viewController.puzzle = self.puzzle
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
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
        
        starsImageView.image = UIImage(named: "star-group-" + String(currentStars))
        
        self.setUserPicture(profilePicture)
    }
}
