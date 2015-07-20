//
//  GiveUpViewController.swift
//  Compound
//
//  Created by Daniel Maness on 4/21/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit

class GiveUpViewController: BaseViewController {
    /* Actions */
    @IBAction func onYesPressed(sender: UIButton) {
        self.view.removeFromSuperview()
        (self.parentViewController as! PuzzleViewController).endPuzzle(Status.GaveUp)
    }

    @IBAction func onNoPressed(sender: UIButton) {
        self.view.removeFromSuperview()
        (self.parentViewController as! PuzzleViewController).showKeyboard()
    }
    
    /* Setup */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiView = self.view as UIView
        setupView()
    }
    
    func setupView() {
    
    }
}