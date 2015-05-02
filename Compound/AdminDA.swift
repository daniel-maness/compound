//
//  AdminDA.swift
//  Compound
//
//  Created by Daniel Maness on 4/30/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

/********** Admin Functions **********/
class AdminDA {
    let userDA = UserDA()
    let puzzleDA = PuzzleDA()
    
    func populateWordTable() {
        var streamReader = StreamReader(fileName: "keywords")
        var rawList: Array<NSString> = streamReader.getWords()
        
        for word in rawList {
            insertWord(word as String)
        }
    }

    func populateCombinationTable() {
        var words = puzzleDA.getAllWords()
        
        var streamReader = StreamReader(fileName: "combinations")
        var rawList: Array<NSString> = streamReader.getWords()
        
        for combo in rawList {
            for word in words {
                if (combo.containsString(word.Name)) {
                    var firstWord = combo.substringToIndex(count(word.Name))
                    if firstWord == word.Name {
                        var secondWord = combo.substringFromIndex(count(firstWord))
                        if puzzleDA.getCombinationId(firstWord, secondWord: secondWord) == 0 {
                            insertCombination(firstWord, secondWord: secondWord)
                        }
                    } else {
                        firstWord = combo.substringToIndex(combo.length - count(word.Name))
                        var secondWord = combo.substringFromIndex(combo.length - count(word.Name))
                        
                        if secondWord == word.Name && puzzleDA.getCombinationId(firstWord, secondWord: secondWord) == 0 {
                            insertCombination(firstWord, secondWord: secondWord)
                        }
                    }
                }
            }
        }
    }

    func insertWord(name: String) {
        let db = SQLiteDB.sharedInstance()
        let result = db.execute("INSERT INTO Word (Name) VALUES ('" + name + "')")
    }

    func insertCombination(firstWord: String, secondWord: String) {
        let db = SQLiteDB.sharedInstance()
        let first = db.query("SELECT WordId FROM Word WHERE Name = '" + firstWord + "'")
        let second = db.query("SELECT WordId FROM Word WHERE Name = '" + secondWord + "'")
        
        let firstId = first[0]["WordId"]?.asString()
        let secondId = second[0]["WordId"]?.asString()
        
        let result = db.execute("INSERT INTO Combination (FirstWordId, SecondWordId) VALUES (" + firstId! + ", " + secondId! + ")")
    }

    func generatePuzzles() {
        let db = SQLiteDB.sharedInstance()
        var words = puzzleDA.getAllWords()
        
        for word in words {
            var allPuzzles = Array<Array<Combination>>()
            var combinations = puzzleDA.getAllCombinations(word)
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
                            let combinationId1 = String(puzzle[0].combinationId)
                            let combinationId2 = String(puzzle[1].combinationId)
                            let combinationId3 = String(puzzle[2].combinationId)
                            
                            let data = db.query("SELECT PuzzleId FROM Puzzle p WHERE p.WordId = " + wordId +
                                " AND p.CombinationId1 = " + combinationId1 +
                                " AND p.CombinationId2 = " + combinationId2 +
                                " AND p.CombinationId3 = " + combinationId3)
                            if data.count == 0 {
                                db.query("INSERT INTO PUZZLE (WordId, CombinationId1, CombinationId2, CombinationId3) VALUES (" + wordId + ", " + combinationId1 + ", " + combinationId2 + ", " + combinationId3 + ")")
                            }
                    }
                }
            }
        }
    }

    private func sliceArray(var arr: Array<Combination>, x1: Int, x2: Int) -> Array<Combination> {
        var tt: Array<Combination> = []
        for var ii = x1; ii <= x2; ++ii {
            tt.append(arr[ii])
        }
        return tt
    }

    private func findCombinations(var arr: Array<Combination>, k: Int) -> Array<Array<Combination>> {
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
