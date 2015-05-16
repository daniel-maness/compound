//
//  ParseSyncer.swift
//  compound
//
//  Created by Daniel Maness on 5/14/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import Foundation
import Parse

//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            println("Object has been saved.")
//        }

class SyncHelper
{
    var lastSyncTimeStamp: String = DateTime.now()
    var lastPuzzleSync: String = DateTime.now()
    
    func syncPuzzleData() {
        // sync word table
        let word = PFObject(className: "Word")
        
        
        // sync combination table
        
        
        // sync puzzle table
        
    }
}

var syncHelper = SyncHelper()