//
//  TotalStarsProgressView.swift
//  Compound
//
//  Created by Daniel Maness on 10/20/15.
//  Copyright © 2015 Devious Logic. All rights reserved.
//

import UIKit

class TotalStarsProgressView: UIView {
    let starLevels: [Float] = [0, 5, 15, 30, 50]
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
        
        for i in 0..<starLevels.count {
            if Float(totalStars) < starLevels[i] {
                currentStarsForLevel = Float(totalStars) - starLevels[i-1]
                starsForNextLevel = starLevels[i] - starLevels[i-1]
                level = i + 1
                break
            }
        }
        
        progressBar.progressImage = UIImage(named: "bar-\(level).png")
        progressBar.progress = currentStarsForLevel / starsForNextLevel
        progressBar.transform = CGAffineTransformScale(progressBar.transform, 1, 50)
    }
    
    func getTotalStars() -> Int {
        return 20
    }
}
