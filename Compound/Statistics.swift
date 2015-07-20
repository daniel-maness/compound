//
//  Statistics.swift
//  Compound
//
//  Created by Daniel Maness on 7/20/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation

class Statistics {
    var totalPuzzlesCompleted: Int!
    var totalPuzzlesTimeUp: Int!
    var totalPuzzlesGaveUp: Int!
    var totalHintsUsed: Int!
    var totalSecondsPlayed: Int!
    var fourStarsEarned: Int!
    var threeStarsEarned: Int!
    var twoStarsEarned: Int!
    var oneStarsEarned: Int!
    
    var totalPuzzlesPlayed: Int {
        return totalPuzzlesCompleted + totalPuzzlesGaveUp + totalPuzzlesTimeUp
    }
    
    var totalStarsEarned: Int {
        return fourStarsEarned * 4 + threeStarsEarned * 3 + twoStarsEarned * 2 + oneStarsEarned
    }
    
    var averageStars: Double {
        return totalPuzzlesPlayed == 0 ? 0.0 : Double(totalStarsEarned) / Double(totalPuzzlesPlayed)
    }
    
    var averageTime: Int {
        return totalPuzzlesPlayed == 0 ? 0 : totalSecondsPlayed / totalPuzzlesPlayed
    }
    
    init() {
        
    }
}