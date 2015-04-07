//
//  itemDetail.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/6/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import UIKit

class itemDetail: UIViewController {

    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemDescr: UILabel!

    var DEBUG:Bool = false;
    var resetData:Bool = false;
    var items: NSArray!
    var index: Int!
    var caller: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG = testingService().canDebug();
        resetData = testingService().resetUserData();
        var count = items.count;

        var sharName: String = items[index]["shar_name"] as String;
        self.itemName.text = sharName;
        
        var description: String = items[index]["description"] as String;
        self.itemDescr.text = description;
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        
    }
    
    
    
    
    
}
