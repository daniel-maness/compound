//
//  PuzzleDA.swift
//  Compound
//
//  Created by Daniel Maness on 11/14/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation

class PuzzleDA {
    func getAllWords() -> [Word] {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM Word")
        
        var words = [Word]()
        for row in data {
            let id = row["WordId"]?.asInt()
            let name = row["Name"]?.asString()
            words.append(Word(id: id!, name: name!))
        }
        
        return words
    }
    
    func getAllWordsUppercase() -> [Word] {
        var words = getAllWords()
        for word in words {
            word.Name = word.Name.uppercaseString
        }
        return words
    }
    
    func getAllCombinations(keyword: Word) -> [Combination] {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM viCombination c WHERE c.FirstId = " + String(keyword.Id) + " OR c.SecondId = " + String(keyword.Id))
        var combinations = [Combination]()
        
        for row in data {
            let wordPairId = row["WordPairId"]!.asInt()
            let first = Word(id: row["FirstId"]!.asInt(), name: String(row["FirstName"]!.asString()).uppercaseString)
            let second = Word(id: row["SecondId"]!.asInt(), name: String(row["SecondName"]!.asString()).uppercaseString)
            combinations.append(Combination(wordPairId: wordPairId, keyword: keyword, leftWord: first, rightWord: second))
        }
        
        return combinations
    }
    
    func getPuzzle() -> Puzzle {
        var puzzle = Puzzle()
        
        return puzzle
    }
    
    func getPuzzle(id: Int) -> Puzzle {
        var puzzle = Puzzle()
        
        return puzzle
    }
    
    func savePuzzle(puzzle: Puzzle) {
        
    }
    
    func deletePuzzle(id: Int) {
        
    }
    
    /********** Database Functions **********/
    
    func populateWordTable() {
        var streamReader = StreamReader(fileName: "keywords")
        var rawList: Array<NSString> = streamReader.getWords()
        
        for word in rawList {
            insertWord(word as String)
        }
    }
    
    func populateWordPairTable() {
        var words = getAllWords()

        var streamReader = StreamReader(fileName: "combinations")
        var rawList: Array<NSString> = streamReader.getWords()
        
        for combo in rawList {
            for word in words {
                if (combo.containsString(word.Name)) {
                    var firstWord = combo.substringToIndex(count(word.Name))
                    if firstWord == word.Name {
                        var secondWord = combo.substringFromIndex(count(firstWord))
                        if getWordPairId(firstWord, secondWord: secondWord) == 0 {
                                insertWordPair(firstWord, secondWord: secondWord)
                        }
                    } else {
                        firstWord = combo.substringToIndex(combo.length - count(word.Name))
                        var secondWord = combo.substringFromIndex(combo.length - count(word.Name))
                        
                        if secondWord == word.Name && getWordPairId(firstWord, secondWord: secondWord) == 0 {
                            insertWordPair(firstWord, secondWord: secondWord)
                        }
                    }
                }
            }
        }
    }
    
    func getWord(name: String) -> Word {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM Word WHERE Name = '" + name + "'")
        
        if (data.count == 0) {
            return Word(id: 0, name: "")
        }
        
        return Word(id: data[0]["WordId"]!.asInt(), name: data[0]["Name"]!.asString())
    }
    
    func getWordPairId(firstWord: String, secondWord: String) -> Int {
        let db = SQLiteDB.sharedInstance()
        let first = getWord(firstWord)
        let second = getWord(secondWord)
        
        if (first.Id > 0 && second.Id > 0) {
            let data = db.query("SELECT WordPairId FROM WordPair WHERE FirstWordId = " + String(first.Id) + " AND SecondWordId = " + String(second.Id))
            
            if (data.count > 0) {
                return data[0]["WordPairId"]!.asInt()
            }
            
            return 0
        }
        
        return -1
    }
    
    func insertWord(name: String) {
        let db = SQLiteDB.sharedInstance()
        let result = db.execute("INSERT INTO Word (Name) VALUES ('" + name + "')")
    }
    
    func insertWordPair(firstWord: String, secondWord: String) {
        let db = SQLiteDB.sharedInstance()
        let first = db.query("SELECT WordId FROM Word WHERE Name = '" + firstWord + "'")
        let second = db.query("SELECT WordId FROM Word WHERE Name = '" + secondWord + "'")
        
        let firstId = first[0]["WordId"]?.asString()
        let secondId = second[0]["WordId"]?.asString()
        
        let result = db.execute("INSERT INTO WordPair (FirstWordId, SecondWordId) VALUES (" + firstId! + ", " + secondId! + ")")
    }
    
    func generatePuzzles() {
        let db = SQLiteDB.sharedInstance()
        var words = getAllWords()
        
        for word in words {
            var allPuzzles = Array<Array<Combination>>()
            var combinations = getAllCombinations(word)
            let r = 3
            if combinations.count >= r {
                allPuzzles = findCombinations(combinations, k: 3)
                for puzzle in allPuzzles {
                    if puzzle[0].keyword == puzzle[1].keyword &&
                       puzzle[0].keyword == puzzle[2].keyword &&
                       puzzle[0].combinedWord != puzzle[1].combinedWord &&
                       puzzle[0].combinedWord != puzzle[2].combinedWord &&
                       puzzle[1].combinedWord != puzzle[2].combinedWord {
                        let wordId = String(puzzle[0].keyword.Id)
                        let wordPairId1 = String(puzzle[0].wordPairId)
                        let wordPairId2 = String(puzzle[1].wordPairId)
                        let wordPairId3 = String(puzzle[2].wordPairId)
                        
                        let data = db.query("SELECT PuzzleId FROM Puzzle p WHERE p.WordId = " + wordId +
                                            " AND p.WordPairId1 = " + wordPairId1 +
                                            " AND p.WordPairId2 = " + wordPairId2 +
                                            " AND p.WordPairId3 = " + wordPairId3)
                        if data.count == 0 {
                            db.query("INSERT INTO PUZZLE (WordId, WordPairId1, WordPairId2, WordPairId3) VALUES (" + wordId + ", " + wordPairId1 + ", " + wordPairId2 + ", " + wordPairId3 + ")")
                        }
                    }
                }
            }
        }
    }
    
    func sliceArray(var arr: Array<Combination>, x1: Int, x2: Int) -> Array<Combination> {
        var tt: Array<Combination> = []
        for var ii = x1; ii <= x2; ++ii {
            tt.append(arr[ii])
        }
        return tt
    }
    
    func findCombinations(var arr: Array<Combination>, k: Int) -> Array<Array<Combination>> {
        var i: Int
        var subI : Int
        
        var ret: Array<Array<Combination>> = []
        var sub: Array<Array<Combination>> = []
        var next: Array<Combination> = []
        for var i = 0; i < arr.count; ++i {
            if(k == 1){
                ret.append([arr[i]])
            }else {
                sub = findCombinations(sliceArray(arr, x1: i + 1, x2: arr.count - 1), k: k - 1)
                for var subI = 0; subI < sub.count; ++subI {
                    next = sub[subI]
                    next.insert(arr[i], atIndex: 0)
                    ret.append(next)
                }
            }
            
        }
        return ret
    }

}
