//
//  EVLocationService.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import SwiftyJSON

class EVLocationService: BaseService {

    class func getAllSupplierLocation() -> Observable<[EVLocation]> {
        
        return Observable.create({ (sub) -> Disposable in
            sub.onNext(EVSupplier.current!.locations)
            
            sessionManager.request(EVSupplierAPI.location.path(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (respone) in
                
                if  let responeT = respone.response,
                    let dataJSON = respone.data,
                    responeT.statusCode == 200  {
                    
                    let json = JSON(dataJSON)
                    _ = EVLocation.fromServerJSON(json)
                }
                
                sub.onNext(EVSupplier.current!.locations)
            }
            
            return Disposables.create()
        }).observeOn(MainScheduler.asyncInstance)
    }
}
