//
//  registerController.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class registerController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtSignupUsername: UITextField!
    @IBOutlet weak var txtSignupPassword: UITextField!
    @IBOutlet weak var txtSignupPasswordConfirm: UITextField!
    @IBOutlet weak var txtSignupZipcode: UITextField!
    @IBOutlet weak var txtSignupEmail: UITextField!
 
    var server = networkService().servername() + "/register";
    var useNetwork  = networkService().bypass();
    var DEBUG = testingService().canDebug();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSignupEmail.delegate = self
        self.txtSignupUsername.delegate = self
        self.txtSignupPassword.delegate = self
        self.txtSignupPasswordConfirm.delegate = self
        
        if(DEBUG) {
            NSLog("LoginVC - server being used: %@", server);
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerTapped(sender: UIButton) {
        var username:NSString = txtSignupUsername.text as NSString
        var password:NSString = txtSignupPassword.text as NSString
        var confirm_password:NSString = txtSignupPasswordConfirm.text as NSString
        var email:NSString = txtSignupEmail.text as NSString
        var zipcode:NSString = txtSignupZipcode.text as NSString
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Please enter a username and password."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if ( !password.isEqual(confirm_password) ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Passwords don't match!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        }
        else if (zipcode.length != 0 && zipcode.length != 5) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Incorrect zipcode."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            if(useNetwork) {
                var post:NSString = "username=\(username)&password=\(password)&email_address=\(email)&zip_code=\(zipcode)"
                
                if(DEBUG) {NSLog("PostData: %@",post);}
                
                var urlStr : NSString = server.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                var url:NSURL = NSURL(string:urlStr as String)!

                var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                var postLength:NSString = String( postData.length )
                
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    if(DEBUG) {NSLog("Response code: %ld", res.statusCode);}
                    
                    var cookie = NSHTTPCookie.cookiesWithResponseHeaderFields(res.allHeaderFields, forURL: url)
                    
                    
                    if(DEBUG) {NSLog("Cookie: %@", cookie);}
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        if(DEBUG) {NSLog("Response ==> %@", responseData);}
                        
                        var error: NSError?
                        
                        let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                        
                        
                        let success:NSString = jsonData.valueForKey("success") as! NSString
                        
                        
                        
                        if(DEBUG) {NSLog("Success: %@", success);}
                        
                        if(success == "true")
                        {
                            if(DEBUG) {NSLog("Sign Up SUCCESS");}
                            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.setObject(password, forKey: "PASSWORD")
                            prefs.synchronize()
                            
                            self.performSegueWithIdentifier("registerTOoverviewSegue", sender: self)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["errorMessage"] as? NSString != nil {
                                error_msg = jsonData["errorMessage"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Sign Up Failed!"
                            alertView.message = error_msg as String
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                        }
                        
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = "Connection Failed"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }  else {
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
            else {
                if(DEBUG) {NSLog("Sign Up BYPASSED");}
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject("networkBypassed", forKey: "USERNAME")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")

                
                
                
                prefs.synchronize()
                
                self.performSegueWithIdentifier("registerTOoverviewSegue", sender: self)
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func gotoLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
