//
//  AnswerView.swift
//  Compound
//
//  Created by Daniel Maness on 8/20/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import UIKit

@IBDesignable class AnswerView: UIView {
    var keyword: String!
    var view: UIView!
    var fontSize: CGFloat!
    
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var wordLabel3: UILabel!
    
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
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AnswerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setText(word1: String, word2: String, word3: String, keyword: String, fontSize: CGFloat = 16.0) {
        self.keyword = keyword
        self.fontSize = fontSize
        
        wordLabel1.attributedText = formatWord(word1)
        wordLabel2.attributedText = formatWord(word2)
        wordLabel3.attributedText = formatWord(word3)
    }
    
    func formatWord(word: String) -> NSMutableAttributedString {
        var leftWord = word.substringTo(self.keyword.characters.count)
        var rightWord: String

        if leftWord == self.keyword {
            rightWord = word.substringFrom(self.keyword.characters.count - 1)
        } else {
            leftWord = word.substringTo(word.characters.count - self.keyword.characters.count - 1)
            rightWord = word.substringFrom(leftWord.characters.count)
        }
        
        let location = leftWord == self.keyword ? 0 : leftWord.characters.count
        let length = self.keyword.characters.count
        let attributedString = NSMutableAttributedString(string: leftWord.uppercaseString + rightWord.uppercaseString)

        attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
        //attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(self.fontSize), range: NSMakeRange(location, length))

        return attributedString
    }
}