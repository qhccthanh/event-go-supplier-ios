//
//  ImageStore.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImageStore {
    
    var id: String = ""
    var supplierId: String = ""
    var name: String = ""
    var detail: String = ""
    var url: String = ""
    var create: Double = 0
    var tags: [String] = [String]()
    var image: UIImage = UIImage()
    var isChecked: Bool = false
    
    init(data: JSON) {
        self.id = data["_id"].stringValue
        self.supplierId = data["supplier_id"].stringValue
        self.name = data["name"].stringValue
        self.detail = data["detail"].stringValue
        self.url = data["image_url"].stringValue
    }
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}

struct ListSuppierImage {
    var listImage: Array<ImageStore> = Array<ImageStore>()
    init(data: JSON) {
        listImage = data["data"].arrayValue.map({ ImageStore(data: $0)})
    }
}
