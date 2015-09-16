//
//  ProgressView.swift
//  Compound
//
//  Created by Daniel Maness on 8/21/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import UIKit

@IBDesignable class ProgressView: UIView {
    var totalStars: Int!
    var totalTrophies: Int!
    var view: UIView!
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var starBar: UIProgressView!
    @IBOutlet weak var trophyBar: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ProgressView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}