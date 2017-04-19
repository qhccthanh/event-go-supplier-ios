//
//  EVImageServices.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveSwift
import Alamofire
class EVImageServices: BaseService {
    
    static var shareInstance: EVImageServices = EVImageServices()
    
    func uploadImage(imageStore: ImageStore, callback: @escaping (ImageStore) -> Void){
        var params = Dictionary<String, Any>()
        var paramImage = Dictionary<String, String>()
        paramImage["name"] = imageStore.name
        paramImage["detail"] = imageStore.detail
        
        let imageData: Data = UIImagePNGRepresentation(imageStore.image)!
        let base64Encode = imageData.base64EncodedString()
        params["file_encode_64"] = base64Encode
        params["image_description"] = paramImage
        sessionManager.request(EVSupplierAPI.image.path(), method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (respone) in
            if respone.response?.statusCode == 200 {
                let dataJson = JSON(respone.data)
                callback(ImageStore(data: dataJson["data"]))
            }
          
        }
    }
    
//    func uploadArrayImage(arrayImage: Array<ImageStore>){
//        for image in arrayImage {
//            uploadImage(imageStore: image, callback: { (result) in
//                <#code#>
//            })
//        }
//    }
    
    func getAllSupplierImage(callback: @escaping (_ result: ListSuppierImage) -> Void){
        sessionManager.request(EVSupplierAPI.image.path(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (respone) in
            if respone.response?.statusCode == 200 {
                let dataJson = JSON(respone.data)
                callback(ListSuppierImage(data: dataJson))
            }
        }
    }
}
