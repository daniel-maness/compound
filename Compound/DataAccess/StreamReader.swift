//
//  StreamReader.swift
//  Compound
//
//  Created by Daniel Maness on 11/26/14.
//  Copyright (c) 2014 Daniel Maness. All rights reserved.
//

import Foundation

class StreamReader {
    let path: String!
    
    init(fileName: String) {
        self.path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
    }
    
    func getWords() -> Array<String> {
        var possibleContent = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        var array = Array<String>()
        
        if let content = possibleContent {
            array = content.componentsSeparatedByString("\n")
        }
        
        return array
    }
}