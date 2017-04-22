//
//  EVGeocode.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/22/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import SwiftyJSON

class EVGeocode: NSObject {
    
    var place_id: String!
    var coordinate: (lat: Double, lng: Double)!
    var formatted_address: String!
    
    class func fromJSON(_ json: JSON) -> EVGeocode {
        
        return EVGeocode().build({
            $0.place_id = json["place_id"].string ?? ""
            $0.formatted_address = json["formatted_address"].string ?? ""
            
            let location = json["geometry"]["location"]
            $0.coordinate = (lat: location["lat"].double ?? Double(0), lng: location["lng"].double ?? Double(0))
        })
    }
    
    func toJSON() -> NSDictionary {
        
        return [
            "place_id": place_id,
            "coordinate": [
                "lat": coordinate.lat,
                "lng": coordinate.lng
            ],
            "formatted_address": formatted_address
        ]
    }
}
