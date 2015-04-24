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
                var count = 0;
                
                var cookiesD:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as! [NSHTTPCookie]
                for cookieD:NSHTTPCookie in cookiesD as [NSHTTPCookie] {
                    println("VC: \(cookieD)");
                    count++;
                }
                var goodCookie = false;
                var response = networkService().parseJSON(networkService().getJSON(networkService().servername() + "/cookiecheck"));
                
                if(DEBUG) {println(response["cookieValid"]);}
                goodCookie = response["cookieValid"] as! Bool;
                
                if(count > 0 && goodCookie) {
                    self.performSegueWithIdentifier("overviewSegue", sender: self)
                }
                else {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
                
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

