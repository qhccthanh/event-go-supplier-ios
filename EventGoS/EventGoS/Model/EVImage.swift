//
//  ImageStore.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import Foundation
import SwiftyJSON

class EVImageResource: NSObject {
    
    var id: String = ""
    var supplierId: String = ""
    var name: String = ""
    var detail: String = ""
    var url: String = ""
    var create: Date = Date()
    var tags: [String] = [String]()
    var image: UIImage = UIImage()
    var isChecked: Bool = false
    
    
    init(data: JSON) {
        super.init()
        
        self.id = data["_id"].stringValue
        self.supplierId = data["supplier_id"].stringValue
        self.name = data["name"].stringValue
        self.detail = data["detail"].stringValue
        
        if let dateString =  data["created_date"].string {
            self.create = Date.fromStringDate(dateString)
        }
        self.url = data["image_url"].stringValue
    }
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    class func fromServerJSON(_ data: JSON) -> [EVImageResource] {
        EVSupplier.current?.images = data["data"].arrayValue.map({
            EVImageResource(data: $0)
        }).sorted(by: {
            return $0.create.timeIntervalSince1970 > $1.create.timeIntervalSince1970
        })
        
        return EVSupplier.current!.images
    }
}

struct ListSuppierImage {
    var listImage: Array<EVImageResource> = Array<EVImageResource>()
    init(data: JSON) {
        listImage = data["data"].arrayValue.map({ EVImageResource(data: $0)})
    }
}
