//
//  profileController.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/18/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//


import UIKit

class profileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var username: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!



    var index: Int!
    var elements: AnyObject!
    var DEBUG = testingService().canDebug();
    var items: [String] = [];
    var server = networkService().servername();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        println(items);
        updateTable("offers")
        username.text = prefs.stringForKey("USERNAME")?.capitalizedString
    }
    
    func updateTable(indexMe: String) {
        elements = networkService().getData(server + "/" + indexMe, index: indexMe);
        items = networkService().getItems(elements);
        println(items)
        tableView.reloadData()
    }
    
    @IBAction func segmentIndex(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex  {
        case 0:
            println("Offers")
            
            updateTable("offers")
        case 1:
            println("Requests")
            
            updateTable("requests")
        case 2:
            self.performSegueWithIdentifier("addItemSegue", sender: self)
        default:
            break;
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row;
        
        //self.performSegueWithIdentifier("offerDetail", sender: self)
    }
}