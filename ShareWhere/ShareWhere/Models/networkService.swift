//
//  networkService.swift
//  ShareWhere
//
//  Created by Dale Driggs on 3/27/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import Foundation

class networkService{
    private let serverID : Int = 3;  // set for the server to use
    private let useNetwork: Bool = true; // when the servers are down, set to false
    
    
    private let server : String = "http://10.171.204.139:8000"; // 0 - on campus only
    private let Jimmy : String = "http://104.211.0.152:80";     // 1 - only up when working together
    private let Grant : String = "http://hernan.de:8000";       // 2 - up, but outdated
    private let DaleUbuServer : String = "http://192.168.1.86:8000";   // 3 - only at home
    
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
            return DaleUbuServer;
        }
        
        return server;
    }
    
    
    
}
