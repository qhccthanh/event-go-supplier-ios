//
//  EVLoginAPI.swift
//  EventGoS
//
//  Created by thanhqhc on 4/14/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import SwiftyJSON


class EVLoginAPI: BaseService {
    
    class func signinWith(username: String, password: String) -> Observable<EVSupplier> {
        
        return Observable.create({ (observer) -> Disposable in
            
            var params = Dictionary<String, Any>()
            params["username"] = username
            params["password"] = password
            sessionManager.request(EVSupplierAPI.login.path(), method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON {
                (response) in
                if  let _ = response.result.value as? NSDictionary,
                    let data = response.data,
                    response.response?.statusCode == 200 {
                    
                    let jsonData = JSON(data: data)
                    let supplier = EVSupplier.fromJson(data: jsonData["data"])
                    observer.onNext(supplier)
                    EVSupplier.current = supplier
                    return
                }
                
                observer.onError(NSError.defaultAPIError())
            }
            
            return Disposables.create()
        }) as Observable<EVSupplier>
       
    }
    
    class func checkLogin() -> Observable<EVSupplier> {
        
        return Observable.create({ (observer) -> Disposable in
            
            self.sessionManager.request(EVSupplierAPI.me.path()).responseJSON {
                (response) in
                if  let _ = response.result.value as? NSDictionary,
                    let data = response.data,
                    response.response?.statusCode == 200 {
                    
                    let jsonData = JSON(data: data)
                    let supplier = EVSupplier.fromJson(data: jsonData["data"])
                    observer.onNext(supplier)
                    EVSupplier.current = supplier
                    return
                }
                
                observer.onError(NSError.defaultAPIError())
            }
            
            return Disposables.create()
        }) as Observable<EVSupplier>
    }
    
    class func signOut() -> Observable<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            sessionManager.request(EVSupplierAPI.logout.path(), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response) in
                if  let _ = response.result.value as? NSDictionary,
                    response.response?.statusCode == 200 {
                    EVSupplier.current = nil
                    observer.onNext(true)
                    return
                }
                observer.onNext(false)
            })
            
            return Disposables.create()
        }) as Observable<Bool>
    }
}

extension NSError {
    class func defaultAPIError() -> NSError {
        return NSError(domain: "com.eventGo", code: 5, userInfo: [NSLocalizedDescriptionKey: "api error"])
    }
}
