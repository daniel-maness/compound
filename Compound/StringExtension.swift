//
//  StringExtension.swift
//  Compound
//
//  Created by Daniel Maness on 9/23/15.
//  Copyright © 2015 Devious Logic. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
    
    func substringTo(index: Int) -> String {
        var substring = ""
        var count = 0
        
        for i in self.characters.indices {
            if count <= index {
                substring.append(self[i])
                count++
            }
        }
        
        return substring
    }
    
    func substringFrom(index: Int) -> String {
        var substring = ""
        var count = 0
        
        for i in self.characters.indices {
            if count >= index {
                substring.append(self[i])
            }
            count++
        }
        
        return substring
    }
    
    func substringWithRange(fromIndex: Int, toIndex: Int) -> String {
        var substring = ""
        var count = 0
        
        for i in self.characters.indices {
            if count >= fromIndex && count <= toIndex {
                substring.append(self[i])
                count++
            }
        }
        
        return substring
    }
}