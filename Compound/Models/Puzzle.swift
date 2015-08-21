//
//  Puzzle.swift
//  Compound
//
//  Created by Daniel Maness on 11/13/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation
import UIKit

enum Status: Int {
    case Incomplete = 0, Complete, TimeUp, GaveUp
}

class Puzzle {
    let maxStars: Int = 4
    let minStars: Int = 1
    
    var puzzleId: Int
    var userPuzzleId: Int!
    var keyword: String
    var combinations: [Combination]
    var startTime: String
    var endTime: String
    var status: Status
    var hintsUsed: Int
    var currentHint: String
    var points: Int
    var ended: Bool
    var time: Int
    var starsEarned: Int {
        return self.status == Status.Complete ? self.maxStars - self.hintsUsed : 0
    }
    
    var currentStars: Int {
        return self.maxStars - self.hintsUsed
    }
    
    init() {
        self.puzzleId = 0
        self.combinations = [Combination]()
        self.keyword = ""
        self.startTime = ""
        self.endTime = ""
        self.status = Status.Incomplete
        self.currentHint = ""
        self.hintsUsed = 0
        self.points = 0
        self.ended = false
        self.time = MAX_TIME
    }
}