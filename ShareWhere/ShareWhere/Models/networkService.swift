//
//  networkService.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import Foundation

class networkService{
    private let serverID : Int = 2;  // set for the server to use
    private let useNetwork: Bool = true; // when the servers are down, set to false
    
    private let server : String = "http://10.171.204.139:8000"; // 0 - on campus only
    private let Jimmy : String = "http://104.211.0.206:80";     // 1 - only up when working together
    private let Grant : String = "http://hernan.de:8000";       // 2 - up, but outdated
    private let UbuLaptop : String = "http://192.168.1.86:8000";   // 3 - only at home
    private let UbuVM: String = "http://192.168.192.140:8000";  // 4 - server vm on mbp
    
    private var items: [String] = [];
    private var jsonData: NSArray = [];
    private var itemIndex = 0;
    
    func bypass() -> Bool {
        return useNetwork;
    }
    
    
    func servername() -> String {
        if(serverID == 1) {
            return Jimmy;
        }
        else if(serverID == 2) {
            return Grant;
        }
        else if(serverID == 3) {
            return UbuLaptop;
        }
        else if(serverID == 4) {
            return UbuVM;
        }
        
        return server;
    }
    
    func getData(url: String, index: String) -> AnyObject {
        
        var parsedJSON = parseJSON(getJSON(url));
        var element = parsedJSON[index] as? NSArray
        return element!;
    }
    
    func getItems(element: AnyObject) -> [String]{
        var count = element.count;
        for(var i = 0; i < count; i++) {
            var test: String = element[i]["shar_name"] as! String;
            items.append(test);
        }
        return items;
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        let data = NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
        
        return data
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return boardsDictionary
    }
    
    func setIndex(index: Int) {
        itemIndex = index;
        println("Ii: \(itemIndex)   in: \(index)");
    }
    
    func getIndex() -> Int {
        return itemIndex;
    }
    
    func getItem() -> NSArray{
        return jsonData as NSArray;
    }
    
    func login() {
        var thisServer = networkService().servername() + "/login";
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var username = prefs.stringForKey("USERNAME");
        var password = prefs.stringForKey("PASSWORD");
        var post:NSString = "username=\(username)&password=\(password)"
        
        var urlStr : NSString = thisServer.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
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
        
        let res = response as! NSHTTPURLResponse!;
        
        var cookie = NSHTTPCookie.cookiesWithResponseHeaderFields(res.allHeaderFields, forURL: url)
        var httpCookie:NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage();
        httpCookie.setCookies(cookie, forURL: url, mainDocumentURL: nil)
    }
}
