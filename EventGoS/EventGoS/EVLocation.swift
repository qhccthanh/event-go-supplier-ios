//
//  EVLocation.swift
//  EventGo-iOSApp
//
//  Created by Quach Ha Chan Thanh on 3/21/17.
//  Copyright © 2017 Quach Ha Chan Thanh. All rights reserved.
//

import UIKit
import SwiftyJSON

class EVLocation: NSObject {

    var location_id: String!
    var supplier_id: String!
    var name: String?
    var detail: String?
    var address: String?
    var image_url: String?
    var created_date: Date = Date()
    var location_info: NSDictionary?
    var tags: [String]?
    var status: String?
    
    class func fromJson(data: JSON) -> EVLocation {
        
        let location = EVLocation()
        location.location_id = data["location_id"].stringValue
        location.supplier_id = data["supplier_id"].stringValue
        location.name = data["name"].stringValue
        location.detail = data["detail"].stringValue
        location.address = data["address"].stringValue
        location.image_url = data["image_url"].arrayValue.first?.string
        if let dateString =  data["created_date"].string {
            location.created_date = Date.fromStringDate(dateString)
        }
        location.location_info = data["location_info"].dictionaryObject as NSDictionary?
        location.status = data["status"].stringValue
        
        return location
    }
    
    class func fromServerJSON(_ data: JSON) -> [EVLocation] {
        EVSupplier.current?.locations = data["data"].arrayValue.map({
            EVLocation.fromJson(data: $0)
        })
        
        return EVSupplier.current!.locations
    }
}
