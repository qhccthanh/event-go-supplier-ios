//
//  EVLoginAPI.swift
//  EventGoS
//
//  Created by thanhqhc on 4/14/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire

let kBaseUrl = "https://evgo.herokuapp.com/api/v1.0/"


enum EVSupplierAPI: String {
    
    case login = "supplier/signIn"
    case me = "supplier/me"
    case location = "locations"
    
    func path() -> String {
        return kBaseUrl.appending(self.rawValue)
    }
}

class EVLoginAPI: NSObject {
    
    func signinWith(username: String, password: String) {
        
    }
    
    func checkLogin() {
        
    }
}
