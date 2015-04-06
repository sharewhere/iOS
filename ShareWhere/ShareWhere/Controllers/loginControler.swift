//
//  loginControler.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class loginController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var server = networkService().servername() + "/login";
    var useNetwork = networkService().bypass();
    var DEBUG = testingService().canDebug();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(DEBUG) {
            NSLog("LoginVC - server being used: %@", server);
            NSLog("LoginVC - Using network: %@", useNetwork ? "True" : "False");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: UIButton) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter a Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            if(useNetwork) {
                
                var post:NSString = "username=\(username)&password=\(password)"
                
                if(DEBUG) { NSLog("PostData: %@",post);}
                
                var urlStr : NSString = server.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                var url:NSURL = NSURL(string:urlStr)!
                
                if(DEBUG) { NSLog("url being used: %@", url);}
                
                var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                var postLength:NSString = String( postData.length )
                
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                
                if ( urlData != nil ) {
                    let res = response as NSHTTPURLResponse!;
                    
                    if(DEBUG) { NSLog("Response code: %ld", res.statusCode);}
                    
                    var cookie = NSHTTPCookie.cookiesWithResponseHeaderFields(res.allHeaderFields, forURL: url)

                    if(DEBUG) { NSLog("Cookie: %@", cookie);}
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        if(DEBUG) { NSLog("Response ==> %@", responseData);}
                        
                        var error: NSError?
                        
                        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                        
                        
                        let success:NSString = jsonData.valueForKey("success") as NSString
                        
                        if(DEBUG) { NSLog("Success: %@", success);}
                        
                        if(success == "true")
                        {
                            if(DEBUG) { NSLog("Login SUCCESS");}
                            
                            
                            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setObject(password, forKey: "PASSWORD")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            // prefs.setObject(cookie, forKey: "COOKIE")
                            prefs.synchronize()
                            
                            
                            self.performSegueWithIdentifier("loginTOoverviewSegue", sender: self)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as NSString
                            } else {
                                error_msg = "Username and/or password incorrect!"
                            }
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Sign in Failed!"
                            alertView.message = error_msg
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                        }
                        
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Connection Failed"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failure"
                    if let error = reponseError {
                        alertView.message = (error.localizedDescription)
                    }
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }
            // when the servers are unavailable or for testing
            else {
                NSLog("Sign Up BYPASSED");
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject("networkBypass", forKey: "USERNAME")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                prefs.synchronize()
                
                self.performSegueWithIdentifier("loginTOoverviewSegue", sender: self)
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
