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
    
    func getAllCombinations(keyword: Word) -> [Combination] {
        let db = SQLiteDB.sharedInstance()
        let data = db.query("SELECT * FROM viCombination c WHERE c.FirstWordId = " + String(keyword.Id) + " OR c.SecondWordId = " + String(keyword.Id))
        var combinations = [Combination]()
        
        for row in data {
            let combinationId = row["CombinationId"]!.asInt()
            let first = Word(id: row["FirstWordId"]!.asInt(), name: String(row["FirstName"]!.asString()))
            let second = Word(id: row["SecondWordId"]!.asInt(), name: String(row["SecondName"]!.asString()))
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
                    String(currentUser.userId) + ", " +
                    String(puzzle.puzzleId) + ", " +
                    String(puzzle.status.rawValue) + ", " +
                    "'" + puzzle.startTime + "', " +
                    "'" + puzzle.endTime + "', " +
                    "" + hintTime1 + ", " +
                    "" + hintTime2 + ", " +
                    "" + hintTime3 + ")")
        
        let userPuzzleId = db.query("SELECT last_insert_rowid() AS userPuzzleId FROM UserPuzzle up WHERE up.UserId = " + String(currentUser.userId))[0]["userPuzzleId"]!.asInt()

        for guess in puzzle.guesses {
            guess.userPuzzleId = userPuzzleId
            db.execute("INSERT INTO Guess (UserPuzzleId, Description, SubmitTime) VALUES(" +
                        String(guess.userPuzzleId) + ", " +
                        "'" + guess.description + "', " +
                        "'" + guess.submitTime + "')")
        }
    }
    
    func deletePuzzle(id: Int) {
        
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
}
