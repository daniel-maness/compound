//
//  Combination.swift
//  Compound
//
//  Created by Daniel Maness on 11/13/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

enum Location: Int {
    case Unknown = 0, Left, Right
}

class Combination {
    var keyword: String
    var leftWord: String
    var rightWord: String
    var keywordLocation: Location
    var combinedWord: String {
        return leftWord + rightWord
    }
    
    var description: String {
        return "combination:\(combinedWord) | keyword:\(keyword)"
    }
    
    init (keyword: String, leftWord: String, rightWord: String) {
        self.keyword = keyword
        self.leftWord = leftWord
        self.rightWord = rightWord
        self.keywordLocation = leftWord == keyword ? Location.Left : Location.Right
    }
    
    init (keyword: String, combinedWord: String) {
        self.keyword = keyword
        self.leftWord = ""
        self.rightWord = ""
        self.keywordLocation = leftWord == keyword ? Location.Left : Location.Right
    }
}

func ==(lhs: Combination, rhs: Combination) -> Bool {
    return lhs.combinedWord == rhs.combinedWord
}