//
//  testingService.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/28/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import Foundation

class testingService{
    private let canResetData: Bool = true; // useful for testing, set NSUserDefaults to nil
    private let DEBUG: Bool = true;        // prints all the log statements
    
    
    // returns whether to reset defaults so we don't have to keep resetting ios simulator manually
    func resetUserData() -> Bool {
        return canResetData;
    }
    
    func canDebug() -> Bool {
        return DEBUG;
    }
    
    
}
