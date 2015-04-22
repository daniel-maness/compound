//
//  PuzzleCompletedViewController.swift
//  Compound
//
//  Created by Daniel Maness on 4/16/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class PuzzleCompletedViewController: BaseViewController {
    /* Properties */
    var word0: NSMutableAttributedString!
    var word1: NSMutableAttributedString!
    var word2: NSMutableAttributedString!
    var currentStars: Int = 0
    var totalStars: Int = 0
    
    /* Outlets */
    @IBOutlet weak var wordLabel0: UILabel!
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var totalStarsLabel: UILabel!
    
    /* Actions */
    @IBAction func onHomePressed(sender: UIButton) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.presentViewController(viewController, animated: true, completion: nil)
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
    }
}
