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
}