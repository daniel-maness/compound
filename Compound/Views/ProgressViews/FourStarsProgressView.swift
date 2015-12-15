//
//  FourStarsProgressView.swift
//  Compound
//
//  Created by Daniel Maness on 10/20/15.
//  Copyright © 2015 Devious Logic. All rights reserved.
//

import UIKit

class FourStarsProgressView: UIView {
    let levels: [Float] = [0, 5, 15, 30, 50]
    let userManager = UserManager()
    var view: UIView!
    
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
        updateProgressBar()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FourStarsProgressView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func updateProgressBar() {
        let totalSteps: Int = getTotalFourStars()
        var stepsForLevel: Float = 0.0
        var stepsForNextLevel: Float = 0.0
        var level: Int = 0
        
        for i in 0..<levels.count {
            if Float(totalSteps) < levels[i] {
                stepsForLevel = Float(totalSteps) - levels[i-1]
                stepsForNextLevel = levels[i] - levels[i-1]
                break
            }
            level++
        }
        
        if level > 0 {
            trophyIcon.image = UIImage(named: "trophy-\(level)")
            progressBar.progressImage = UIImage(named: "bar-\(level).png")
        } else {
            progressBar.progressImage = UIImage(named: "bar-background.png")
        }
        
        progressBar.progress = level >= levels.count ? 1.0 : stepsForLevel / stepsForNextLevel
        progressBar.transform = CGAffineTransformScale(progressBar.transform, 1, 50)
    }
    
    func getTotalFourStars() -> Int {
        return userManager.getStats().fourStarsEarned
    }
}
