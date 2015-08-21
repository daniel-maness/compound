////
////  StringExtensions.swift
////  Compound
////
////  Created by Daniel Maness on 8/20/15.
////  Copyright (c) 2015 Devious Logic. All rights reserved.
////
//
//import Foundation
//
//extension NSMutableAttributedString {
//    func formatIncompleteWord(hint: String, combination: Combination) -> NSMutableAttributedString {
//        var location = combination.keywordLocation == Location.Left ? 0 : count(combination.leftWord)
//        var length = count(hint)
//        var attributedString = NSMutableAttributedString(string: combination.keywordLocation == Location.Left ?
//            hint.uppercaseString + combination.rightWord.uppercaseString :
//            combination.leftWord.uppercaseString + hint.uppercaseString)
//        
////        if length > 0 && puzzle.hintsUsed == MAX_HINTS {
////            attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
////            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(location, 1))
////        }
//        
//        return attributedString
//    }
//    
//    func formatAsIncomplete(keyword: String) -> NSMutableAttributedString {
//        var leftWord = self.string.subStringTo(count(keyword))
//        var rightWord: String
//        
//        if leftWord == keyword {
//            rightWord = self.string.subStringFrom(count(keyword))
//        } else {
//            leftWord = self.string.subStringTo(count(self.string) - count(keyword))
//            rightWord = self.string.subStringFrom(count(leftWord))
//        }
//        
//        self.string = leftWord.uppercaseString + rightWord.uppercaseString
//    
//    }
//    
////    func formatCompleteWord(keyword: String, combination: Combination, fontSize: CGFloat) -> NSMutableAttributedString {
////        var location = combination.keywordLocation == Location.Left ? 0 : count(combination.leftWord)
////        var length = count(keyword)
////        var attributedString = NSMutableAttributedString(string: combination.keywordLocation == Location.Left ?
////            keyword.uppercaseString + combination.rightWord.uppercaseString :
////            combination.leftWord.uppercaseString + keyword.uppercaseString)
////        
////        attributedString.addAttribute(NSForegroundColorAttributeName, value: ColorPalette.black, range: NSMakeRange(location, length))
////        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(fontSize), range: NSMakeRange(location, length))
////        
////        return attributedString
////    }
//}