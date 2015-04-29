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
        let data = db.query("SELECT * FROM viCombination c WHERE c.FirstWordId = " + String(keyword.Id) + " OR c.SecondWordId = " + String(keyword.Id))
        var combinations = [Combination]()
        
        for row in data {
            let combinationId = row["CombinationId"]!.asInt()
            let first = Word(id: row["FirstWordId"]!.asInt(), name: String(row["FirstName"]!.asString()).uppercaseString)
            let second = Word(id: row["SecondWordId"]!.asInt(), name: String(row["SecondName"]!.asString()).uppercaseString)
            combinations.append(Combination(combinationId: combinationId, keyword: keyword, leftWord: first, rightWord: second))
        }
        
        return combinations
    }
    
    func getNewPuzzle() -> Puzzle {
        let db = SQLiteDB.sharedInstance()
        let keywordIds = db.query("SELECT k.KeywordId FROM viKeyword k")
        let keywordId = keywordIds[Int(arc4random_uniform(UInt32(keywordIds.count)))].data["KeywordId"]!.asString()
        
        var puzzleIds = db.query("SELECT DISTINCT p.PuzzleId FROM Puzzle p INNER JOIN UserPuzzle up ON up.PuzzleId != p.PuzzleId WHERE p.WordId = " + String(keywordId))
        if puzzleIds.count == 0 {
            puzzleIds = db.query("SELECT p.PuzzleId FROM Puzzle p WHERE p.WordId = " + String(keywordId))
        }
        
        let puzzleId = puzzleIds[Int(arc4random_uniform(UInt32(puzzleIds.count)))].data["PuzzleId"]!.asInt()
        let puzzle = getPuzzle(puzzleId)
        
        return puzzle
    }
    
    func getPuzzle(id: Int) -> Puzzle {
        var puzzle = Puzzle()
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM viPuzzle p WHERE p.PuzzleId = " + String(id) + " LIMIT 1")
        let row = data[0]
        
        puzzle.puzzleId = id
        puzzle.keyword = Word(id: row["KeywordId"]!.asInt(), name: row["KeywordName"]!.asString())
        
        let combination1 = Combination(combinationId: row["CombinationId1"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId1"]!.asInt(), name: row["FirstName1"]!.asString()), rightWord: Word(id: row["SecondWordId1"]!.asInt(), name: row["SecondName1"]!.asString()))
        let combination2 = Combination(combinationId: row["CombinationId2"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId2"]!.asInt(), name: row["FirstName2"]!.asString()), rightWord: Word(id: row["SecondWordId2"]!.asInt(), name: row["SecondName2"]!.asString()))
        let combination3 = Combination(combinationId: row["CombinationId3"]!.asInt(), keyword: puzzle.keyword, leftWord: Word(id: row["FirstWordId3"]!.asInt(), name: row["FirstName3"]!.asString()), rightWord: Word(id: row["SecondWordId3"]!.asInt(), name: row["SecondName3"]!.asString()))
        
        puzzle.combinations = [combination1, combination2, combination3]
        
        return puzzle
    }
    
    func savePuzzle(puzzle: Puzzle) {
        let db = SQLiteDB.sharedInstance()
        let hintTime1 = puzzle.hintTime1 == "" ? "NULL" : "'" + puzzle.hintTime1 + "'"
        let hintTime2 = puzzle.hintTime2 == "" ? "NULL" : "'" + puzzle.hintTime2 + "'"
        let hintTime3 = puzzle.hintTime3 == "" ? "NULL" : "'" + puzzle.hintTime3 + "'"
        db.execute("INSERT INTO UserPuzzle (UserId, PuzzleId, StatusId, StartTime, EndTime, HintTime1, HintTime2, HintTime3) VALUES(" +
                    String(1) + ", " +
                    String(puzzle.puzzleId) + ", " +
                    String(puzzle.status.rawValue) + ", " +
                    "'" + puzzle.startTime + "', " +
                    "'" + puzzle.endTime + "', " +
                    "" + hintTime1 + ", " +
                    "" + hintTime2 + ", " +
                    "" + hintTime3 + ")")
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
    
    func populateCombinationTable() {
        var words = getAllWords()

        var streamReader = StreamReader(fileName: "combinations")
        var rawList: Array<NSString> = streamReader.getWords()
        
        for combo in rawList {
            for word in words {
                if (combo.containsString(word.Name)) {
                    var firstWord = combo.substringToIndex(count(word.Name))
                    if firstWord == word.Name {
                        var secondWord = combo.substringFromIndex(count(firstWord))
                        if getCombinationId(firstWord, secondWord: secondWord) == 0 {
                                insertCombination(firstWord, secondWord: secondWord)
                        }
                    } else {
                        firstWord = combo.substringToIndex(combo.length - count(word.Name))
                        var secondWord = combo.substringFromIndex(combo.length - count(word.Name))
                        
                        if secondWord == word.Name && getCombinationId(firstWord, secondWord: secondWord) == 0 {
                            insertCombination(firstWord, secondWord: secondWord)
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
    
    func getCombinationId(firstWord: String, secondWord: String) -> Int {
        let db = SQLiteDB.sharedInstance()
        let first = getWord(firstWord)
        let second = getWord(secondWord)
        
        if (first.Id > 0 && second.Id > 0) {
            let data = db.query("SELECT CombinationId FROM Combination WHERE FirstWordId = " + String(first.Id) + " AND SecondWordId = " + String(second.Id))
            
            if (data.count > 0) {
                return data[0]["CombinationId"]!.asInt()
            }
            
            return 0
        }
        
        return -1
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
