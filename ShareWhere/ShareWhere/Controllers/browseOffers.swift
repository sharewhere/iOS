//
//  browseOffersRequests.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/6/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class browseOffers: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var getURL: String = networkService().servername() + "/browseoffers";
    var items :[String] = [];
    var DEBUG = testingService().canDebug();
    var index: Int!
    var elements: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        elements = networkService().getData(getURL, index: "offers");
        items = networkService().getItems(elements);
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row;
        
        self.performSegueWithIdentifier("offerDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "offerDetail") {
            
            var itemView = (segue.destinationViewController as itemDetail)
            itemView.index = index
            itemView.items = elements as NSArray;
            itemView.caller = "offers";
        }
    }
    

}