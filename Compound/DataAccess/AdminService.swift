////
////  AdminService.swift
////  Compound
////
////  Created by Daniel Maness on 4/30/15.
////  Copyright (c) 2015 Daniel Maness. All rights reserved.
////
//
//import Foundation
//import Parse
//import SQLite
//
///********** Admin Classes **********/
//class SqlWord {
//    var Id: Int = 0
//    var Name: String = ""
//    
//    init(id: Int, name: String) {
//        self.Id = id
//        self.Name = name
//    }
//}
//
//class SqlCombination {
//    var combinationId: Int
//    var keyword: SqlWord
//    var leftWord: SqlWord
//    var rightWord: SqlWord
//    var combinedWord: String
//    var keywordLocation: Location
//    
//    var description: String {
//        return "combination:\(combinedWord) | keyword:\(keyword)"
//    }
//    
//    init (combinationId: Int, keyword: SqlWord, leftWord: SqlWord, rightWord: SqlWord) {
//        self.combinationId = combinationId
//        self.keyword = keyword
//        self.leftWord = leftWord
//        self.rightWord = rightWord
//        self.combinedWord = leftWord.Name + rightWord.Name
//        
//        if keyword.Name == leftWord.Name {
//            self.keywordLocation = Location.Left
//        } else {
//            self.keywordLocation = Location.Right
//        }
//    }
//}
//
//func ==(lhs: SqlCombination, rhs: SqlCombination) -> Bool {
//    return lhs.combinedWord == rhs.combinedWord
//}
//
//func ==(lhs: SqlWord, rhs: SqlWord) -> Bool {
//    return lhs.Name == rhs.Name
//}
//
///********** Admin Functions **********/
//class AdminService {
//    let userService = UserService()
//    
//    func populateWordTable() {
//        let streamReader = StreamReader(fileName: "keywords")
//        let rawList: Array<NSString> = streamReader.getWords()
//        
//        for word in rawList {
//            insertWord(word as String)
//        }
//    }
//
//    func populateCombinationTable() {
//        let results = getAllWords()
//        let streamReader = StreamReader(fileName: "combinations")
//        let rawList: Array<NSString> = streamReader.getWords()
//        
//        for combo in rawList {
//            for word in results {
//                if combo.containsString(word.Name) {
//                    var firstWord = combo.substringToIndex(word.Name.characters.count)
//                    if firstWord == word.Name {
//                        let secondWord = combo.substringFromIndex(firstWord.characters.count)
//                        if getCombinationId(firstWord, secondWord: secondWord) == -1 {
//                            insertCombination(firstWord, secondWord: secondWord)
//                        }
//                    } else {
//                        firstWord = combo.substringToIndex(combo.length - word.Name.characters.count)
//                        let secondWord = combo.substringFromIndex(combo.length - word.Name.characters.count)
//                        
//                        if secondWord == word.Name && getCombinationId(firstWord, secondWord: secondWord) == -1 {
//                            insertCombination(firstWord, secondWord: secondWord)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func insertWord(word: String) {
//        do {
//            let db = try Connection("path/to/db.sqlite3")
//            
//            let stmt = db.prepare("INSERT INTO Word (Name) VALUES (?)")
//            try stmt.run(word)
//        } catch {
//            
//        }
//    }
//
//    func insertCombination(firstWord: String, secondWord: String) {
//        do {
//            let db = try Connection("path/to/db.sqlite3")
//            let first = db.prepare("SELECT WordId FROM Word WHERE Name = '" + firstWord + "'")
//            let second = db.prepare("SELECT WordId FROM Word WHERE Name = '" + secondWord + "'")
//            
//            let firstId = first.row["WordId"]?.asString()
//            let secondId = second[0]["WordId"]?.asString()
//            
//            _ = db.execute("INSERT INTO Combination (FirstWordId, SecondWordId) VALUES (" + firstId! + ", " + secondId! + ")")
//        } catch {
//            
//        }
//    }
//    
//    func getAllWords() -> [SqlWord] {
//        let db = SQLiteDB.sharedInstance()
//        let data = db.query("SELECT * FROM Word")
//        
//        var words = [SqlWord]()
//        for row in data {
//            let id: Int! = row["WordId"]?.asInt()
//            let name: String! = row["Name"]?.asString()
//            let word = SqlWord(id: id, name: name)
//            words.append(word)
//        }
//        
//        return words
//    }
//    
//    func getAllCombinations(keyword: SqlWord) -> [SqlCombination] {
//        let db = SQLiteDB.sharedInstance()
//        let data = db.query("SELECT * FROM viCombination c WHERE c.FirstWordId = " + String(keyword.Id) + " OR c.SecondWordId = " + String(keyword.Name))
//        var combinations = [SqlCombination]()
//        
//        for row in data {
//            let combinationId = row["CombinationId"]!.asInt()
//            let first = SqlWord(id: row["FirstWordId"]!.asInt(), name: String(row["FirstName"]!.asString()))
//            let second = SqlWord(id: row["SecondWordId"]!.asInt(), name: String(row["SecondName"]!.asString()))
//            combinations.append(SqlCombination(combinationId: combinationId, keyword: keyword, leftWord: first, rightWord: second))
//        }
//        
//        return combinations
//    }
//    
//    func getWord(name: String) -> SqlWord {
//        let db = SQLiteDB.sharedInstance()
//        let data = db.query("SELECT * FROM Word WHERE Name = '" + name + "'")
//        
//        if (data.count == 0) {
//            return SqlWord(id: 0, name: "")
//        }
//        
//        return SqlWord(id: data[0]["WordId"]!.asInt(), name: data[0]["Name"]!.asString())
//    }
//    
//    func getCombinationId(firstWord: String, secondWord: String) -> Int {
//        let db = SQLiteDB.sharedInstance()
//        let first = getWord(firstWord)
//        let second = getWord(secondWord)
//        
//        if (first.Id > 0 && second.Id > 0) {
//            let data = db.query("SELECT CombinationId FROM Combination WHERE FirstWordId = " + String(first.Id) + " AND SecondWordId = " + String(second.Id))
//            
//            if (data.count > 0) {
//                return data[0]["CombinationId"]!.asInt()
//            }
//            
//            return 0
//        }
//        
//        return -1
//    }
//
//    func generatePuzzles() {
//        let db = SQLiteDB.sharedInstance()
//        let words = getAllWords()
//        
//        for word in words {
//            var allPuzzles = Array<Array<SqlCombination>>()
//            let combinations = getAllCombinations(word)
//            let r = 3
//            if combinations.count >= r {
//                allPuzzles = findCombinations(combinations, k: 3)
//                for puzzle in allPuzzles {
//                    if puzzle[0].keyword == puzzle[1].keyword &&
//                        puzzle[0].keyword == puzzle[2].keyword &&
//                        puzzle[0].combinedWord != puzzle[1].combinedWord &&
//                        puzzle[0].combinedWord != puzzle[2].combinedWord &&
//                        puzzle[1].combinedWord != puzzle[2].combinedWord {
//                            let wordId =  String(puzzle[0].keyword.Id)
//                            let combinationId1 = String(puzzle[0].combinationId)
//                            let combinationId2 = String(puzzle[1].combinationId)
//                            let combinationId3 = String(puzzle[2].combinationId)
//                            
//                            let data = db.query("SELECT PuzzleId FROM Puzzle p WHERE p.WordId = " + wordId +
//                                " AND p.CombinationId1 = " + combinationId1 +
//                                " AND p.CombinationId2 = " + combinationId2 +
//                                " AND p.CombinationId3 = " + combinationId3)
//                            if data.count == 0 {
//                                db.query("INSERT INTO PUZZLE (WordId, CombinationId1, CombinationId2, CombinationId3) VALUES (" + wordId + ", " + combinationId1 + ", " + combinationId2 + ", " + combinationId3 + ")")
//                            }
//                    }
//                }
//            }
//        }
//    }
//
//    private func sliceArray(var arr: Array<SqlCombination>, x1: Int, x2: Int) -> Array<SqlCombination> {
//        var tt: Array<SqlCombination> = []
//        for var ii = x1; ii <= x2; ++ii {
//            tt.append(arr[ii])
//        }
//        return tt
//    }
//
//    private func findCombinations(var arr: Array<SqlCombination>, k: Int) -> Array<Array<SqlCombination>> {
//        var ret: Array<Array<SqlCombination>> = []
//        var sub: Array<Array<SqlCombination>> = []
//        var next: Array<SqlCombination> = []
//        for var i = 0; i < arr.count; ++i {
//            if k == 1 {
//                ret.append([arr[i]])
//            } else {
//                sub = findCombinations(sliceArray(arr, x1: i + 1, x2: arr.count - 1), k: k - 1)
//                for var subI = 0; subI < sub.count; ++subI {
//                    next = sub[subI]
//                    next.insert(arr[i], atIndex: 0)
//                    ret.append(next)
//                }
//            }
//        }
//        return ret
//    }
//}
