//
//  itemDetail.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/6/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class itemDetail: UIViewController {
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var button: UIButton!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemDescr: UILabel!
   

    var DEBUG:Bool = false;
    var resetData:Bool = false;
    var items: NSArray!
    var index: Int!
    var caller: String!
    var itemOwner: String!
    var isMyItem: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let picName: String = items[index]["shar_pic_name"] as? String {
            itemImage.contentMode = UIViewContentMode.ScaleAspectFit
            if let checkedUrl = NSURL(string: networkService().servername() + "/images/" + picName) {
                downloadImage(checkedUrl)
            }
        }
        
       
        
        
        DEBUG = testingService().canDebug();
        resetData = testingService().resetUserData();
        var count = items.count;

        var sharName: String = items[index]["shar_name"] as! String;
        self.itemName.text = sharName;
        
        var description: String = items[index]["description"] as! String;
        self.itemDescr.text = description;
        var server = networkService().servername();
        itemOwner = items[index]["username"] as! String;
        println("itemOwner: \(itemOwner)")
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(prefs.stringForKey("USERNAME") == itemOwner) {
            // this is my item
            button.hidden = true
            isMyItem = true
        }
        else {
            // this is not my item
            isMyItem = false
            
        }
        
        if(caller == "offers" && isMyItem != true) {
            button.setTitle("Request this item!", forState: UIControlState.Normal);
        }
        else if (caller == "requests" && isMyItem != true){
            button.setTitle("Offer a similiar item!", forState: UIControlState.Normal);
        }
    }
    @IBAction func buttonPressed(sender: UIButton) {
        if(caller == "offers") {
            //prepare request segue
        }
        else {
            // prepare offers segue
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)        
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func downloadImage(url:NSURL){
        if(self.DEBUG) {println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")}
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                if(self.DEBUG) {println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")}
                self.itemImage.image = UIImage(data: data!)
            }
        }
    }

    
    
    
    
}
