//
//  TotalStarsProgressView.swift
//  Compound
//
//  Created by Daniel Maness on 10/20/15.
//  Copyright © 2015 Devious Logic. All rights reserved.
//

import UIKit

class TotalStarsProgressView: UIView {
    let levels: [Float] = [0, 5, 15, 30, 50]
    let userManager = UserManager()
    var view: UIView!
    
    @IBOutlet weak var starIcon: UIImageView!
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
        let nib = UINib(nibName: "TotalStarsProgressView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func updateProgressBar() {
        let totalStars: Int = getTotalStars()
        var currentStarsForLevel: Float = 0.0
        var starsForNextLevel: Float = 0.0
        var level: Int = 0
        
        for i in 0..<levels.count {
            if Float(totalStars) < levels[i] {
                currentStarsForLevel = Float(totalStars) - levels[i-1]
                starsForNextLevel = levels[i] - levels[i-1]
                break
            }
            level++
        }
        
        progressBar.progressImage = level > 0 ? UIImage(named: "bar-\(level).png") : UIImage(named: "bar-background.png")
        progressBar.progress = level >= levels.count ? 1.0 : currentStarsForLevel / starsForNextLevel
        progressBar.transform = CGAffineTransformScale(progressBar.transform, 1, 50)
    }
    
    func getTotalStars() -> Int {
        return userManager.getStats().totalStarsEarned
    }
}
