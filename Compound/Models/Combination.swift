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

class Word {
    var Id: Int = 0
    var Name: String = ""
    
    init(id: Int, name: String) {
        self.Id = id
        self.Name = name
    }
}

enum Location: Int {
    case Unknown = 0, Left, Right
}

class Combination: Printable, Hashable {
    var keyword: Word
    var leftWord: Word
    var rightWord: Word
    var combinedWord: String
    var keywordLocation: Location
    
    var description: String {
        return "combination:\(combinedWord) | keyword:\(keyword.Name)"
    }
    
    var hashValue: Int {
        return leftWord.Id * rightWord.Id + leftWord.Id - rightWord.Id
    }
    
    init (keyword: Word, leftWord: Word, rightWord: Word) {
        self.keyword = keyword
        self.leftWord = leftWord
        self.rightWord = rightWord
        self.combinedWord = leftWord.Name + rightWord.Name
        
        if keyword == leftWord {
            self.keywordLocation = Location.Left
        } else {
            self.keywordLocation = Location.Right
        }
    }
}

func ==(lhs: Combination, rhs: Combination) -> Bool {
    return lhs.combinedWord == rhs.combinedWord
}

func ==(lhs: Word, rhs: Word) -> Bool {
    return lhs.Name == rhs.Name
}