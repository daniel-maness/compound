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
    private var word1: String!
    private var word2: String!
    private var word3: String!
    private var keyword: String!
    
    /* Properties */
    var currentStars: Int = 0
    var totalStars: Int = 0
    var puzzle: Puzzle!
    
    /* Outlets */
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var answerView: AnswerView!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        self.showHomeViewController()
    }
    
    @IBAction func onChallengePressed(sender: UIButton) {
        // This method is good for showing a view we may need to return from
        var viewController = UIStoryboard(name: "Puzzle", bundle: nil).instantiateViewControllerWithIdentifier("ChallengePuzzleViewController") as! ChallengePuzzleViewController
        viewController.setAnswerView(self.word1, word2: self.word2, word3: self.word3, keyword: self.keyword)
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
        answerView.setText(self.word1, word2: self.word2, word3: self.word3, keyword: self.keyword)
        totalStarsLabel.text = String(totalStars)
        starsImageView.image = UIImage(named: "star-group-" + String(currentStars))
        self.setUserPicture(profilePicture)
    }
    
    func setAnswerView(word1: String, word2: String, word3: String, keyword: String) {
        self.word1 = word1
        self.word2 = word2
        self.word3 = word3
        self.keyword = keyword
    }
}
