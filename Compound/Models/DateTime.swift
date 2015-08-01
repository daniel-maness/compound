//
//  DateTime.swift
//  Compound
//
//  Created by Daniel Maness on 4/30/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation

class DateTime {
    class func now() -> String {
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        let datetime = dateFormatter.stringFromDate(date)
        return datetime
    }
    
    class func getFormattedSeconds(seconds: Int) -> String {
        if seconds == 60 {
            return "1:00"
        } else if seconds <= 10 {
            if seconds == 10 {
                return "0:" + String(seconds)
            } else {
                return "0:0" + String(seconds)
            }
        } else {
            return "0:" + String(seconds)
        }
    }
}