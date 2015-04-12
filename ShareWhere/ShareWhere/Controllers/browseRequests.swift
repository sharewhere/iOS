//
//  browseRequests.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/6/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class browseRequests: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var getURL: String = networkService().servername() + "/browserequests";
    var items :[String] = [];
    var DEBUG = testingService().canDebug();
    var elements: AnyObject!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.backgroundColor =
        
        elements = networkService().getData(getURL, index: "requests");
        items = networkService().getItems(elements);
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.backgroundColor = UIColor.clearColor();
        cell.textLabel?.textColor = UIColor.whiteColor();
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row;
        self.performSegueWithIdentifier("requestDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "requestDetail") {
            
            var itemView = (segue.destinationViewController as itemDetail)
            itemView.index = index
            itemView.items = elements as NSArray;
            itemView.caller = "requests";
        }
    }
}