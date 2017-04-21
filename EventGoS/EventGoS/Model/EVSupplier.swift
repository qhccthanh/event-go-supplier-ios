//
//  EVSupplier.swift
//  EventGo-iOSApp
//
//  Created by Quach Ha Chan Thanh on 3/21/17.
//  Copyright © 2017 Quach Ha Chan Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class EVSupplier: NSObject {

    static var current: EVSupplier?
    
    var supplier_id: String!
    var name: String!
    var image_url: String?
    var level: Int = 1
    var company_info: NSDictionary?
    var status: String!
    var tags: [String]?
    
    dynamic var locations: [EVLocation] = []
    dynamic var images: [EVImageResource] = []
    
    class func fromJson(data: JSON) -> EVSupplier {
        
        let supplier = EVSupplier()
        
        supplier.supplier_id = data["supplier_id"].stringValue
        supplier.name = data["name"].stringValue
        supplier.image_url = data["image_urL"].stringValue
        supplier.level = data["level"].intValue
        supplier.company_info = data["company_info"].dictionaryObject as NSDictionary?
        supplier.status = data["status"].stringValue
        
        return supplier
    }
    
    class func toJson(supplier: EVSupplier) ->  Dictionary<String,Any> {
        
        var supplierJson = Dictionary<String, Any>()
        
        supplierJson["supplier_id"] = supplier.supplier_id
        supplierJson["name"] = supplier.name
        supplierJson["image_url"] = supplier.image_url
        supplierJson["level"] = supplier.level
        supplierJson["status"] = supplier.status
        
        return supplierJson
    }
}
