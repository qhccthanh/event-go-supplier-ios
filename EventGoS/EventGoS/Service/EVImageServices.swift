//
//  EVImageServices.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift
import RxCocoa

class EVImageServices: BaseService {
    
    static var shareInstance: EVImageServices = EVImageServices()
    
    class func uploadImage(imageStore: EVImageResource) -> Observable<EVImageResource> {
        
        var params = Dictionary<String, Any>()
        var paramImage = Dictionary<String, String>()
        paramImage["name"] = imageStore.name
        paramImage["detail"] = imageStore.detail
        
        let imageData: Data = UIImageJPEGRepresentation(imageStore.image, 0.8)!
        let base64Encode = imageData.base64EncodedString()
        params["file_encode_64"] = base64Encode
        params["image_description"] = paramImage
        
        return Observable.create({ (sub) -> Disposable in
            
            sessionManager.request(EVSupplierAPI.image.path(),
                                   method: .post,
                                   parameters: params,
                                   encoding: JSONEncoding.default,
                                   headers: self.headers)
                .responseJSON { (respone) in
                
                guard let responeT = respone.response,
                    let dataJSON = respone.data,
                    respone.error == nil,
                    responeT.statusCode == 200 else {
                        sub.onError(NSError.defaultAPIError())
                        return
                }
                let json = JSON(dataJSON)
                let image = EVImageResource(data: json["data"])
                sub.onNext(image)
            }
            
            return Disposables.create()
        })
    }
    
    class func getAllSupplierImage() -> Observable<[EVImageResource]> {
        
        return Observable.create({ (sub) -> Disposable in
            sub.onNext(EVSupplier.current!.images)
            
            sessionManager.request(EVSupplierAPI.image.path(),
                                   method: .get,
                                   parameters: nil,
                                   encoding: JSONEncoding.default,
                                   headers: self.headers)
                .responseJSON { (respone) in
                
                if  let responeT = respone.response,
                    let dataJSON = respone.data,
                    responeT.statusCode == 200  {
                
                    let json = JSON(dataJSON)
                    _ = EVImageResource.fromServerJSON(json)
                }
                
                sub.onNext(EVSupplier.current!.images)
            }
            
            return Disposables.create()
        }).observeOn(MainScheduler.asyncInstance)
    }
    
    class func deleteSupplierImage(_ id: String) -> Observable<Bool> {
        
        return Observable.create({ (sub) -> Disposable in
            
            sessionManager.request(EVSupplierAPI.image.path().appending("/\(id)"),
                                   method: .delete,
                                   parameters: nil,
                                   encoding: JSONEncoding.default,
                                   headers: self.headers)
                .responseJSON { (respone) in
                    
                    guard let responeT = respone.response,
                        let _ = respone.data,
                        respone.error == nil,
                        responeT.statusCode == 200 else {
                            sub.onNext(false)
                            return
                    }
                    
                    sub.onNext(true)
            }
            
            return Disposables.create()
        })
    }
}
