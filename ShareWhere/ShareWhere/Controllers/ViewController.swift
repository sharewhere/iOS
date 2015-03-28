//
//  ViewController.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.

//
//  ViewController.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.

import UIKit

class ViewController: UIViewController {
    var DEBUG:Bool = false;
    var resetData:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DEBUG = testingService().canDebug();
        resetData = testingService().resetUserData();
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var keyCount = NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys.array.count;
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
        if(resetData) {
            if(DEBUG) {
                NSLog("ViewController: Reseting key : value store");
            }
            for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
            }
        }
        
        
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
            if (isLoggedIn != 1) {
                // log in view
                self.performSegueWithIdentifier("loginSegue", sender: self)
                
                
            } else {
                // overview
                self.performSegueWithIdentifier("overviewSegue", sender: self)
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

