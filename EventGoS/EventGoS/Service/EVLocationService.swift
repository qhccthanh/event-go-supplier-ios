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
    
    class func createSupplierLocation(_ location: EVLocation) -> Observable<EVLocation> {
        
        let param = [
            "name": location.name ?? "",
            "detail": location.detail ?? "",
            "address": location.address ?? "",
            "image_url": location.image_url ?? "",
            "location_info": location.location_info ?? [:]
        ] as [String : Any]
        
        return Observable.create({
            (sub) -> Disposable in
            
            sessionManager.request(EVSupplierAPI.location.path(),
                                   method: .post,
                                   parameters: param,
                                   encoding: JSONEncoding.default,
                                   headers: self.headers)
                .responseJSON {
                    (respone) in
                    
                    if  let responeT = respone.response,
                        let dataJSON = respone.data,
                        responeT.statusCode == 200  {
                        
                        let json = JSON(dataJSON)
                        let location = EVLocation.fromJson(data: json["data"])
                        sub.onNext(location)
                    }
                    
                    sub.onError(NSError.defaultAPIError())
            }
                                
            return Disposables.create()
        })
    }
    
    class func deleteSupplierLocation() -> Observable<Bool> {
        
        return Observable.create({
            (sub) -> Disposable in
            
            sessionManager.request(EVSupplierAPI.location.path(),
                                   method: .delete,
                                   parameters: nil,
                                   encoding: JSONEncoding.default,
                                   headers: self.headers)
                .responseJSON {
                    (respone) in
                    
                    if  let responeT = respone.response,
                        let _ = respone.data,
                        responeT.statusCode == 200  {
                        
                        sub.onNext(true)
                        return
                    }
                    
                    sub.onNext(false)
                }
            
            return Disposables.create()
        })
    }
    
    class func getLocationInfo(lat: Double, lng: Double) -> Observable<[EVGeocode]> {
        return Observable.create({
            (sub) -> Disposable in
            
            sessionManager.request(getLocationRequest(lat,lng: lng),
                                   method: .get,
                                   parameters: nil,
                                   encoding: JSONEncoding.default,
                                   headers: nil)
            .responseJSON {
                response in
                
                if  let _ = response.response,
                    let dataJSON = response.data,
                    let json = JSON(data: dataJSON).dictionary,
                    let status = json["status"]?.string,
                    let results = json["results"]?.array,
                    status == "OK"
                {
                    
                    let geocodes = results.map {
                        return EVGeocode.fromJSON($0)
                    }
                    return
                }
                
                sub.onError(NSError.defaultAPIError())
            }
            
            return Disposables.create()
        })
    }
    
    //  "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyCRymVmfMFKrVCT3fn1El_KDQKSWA4rErQ"
    private class func getLocationRequest(_ lat: Double, lng: Double) -> String {
        let baseURL = "https://maps.googleapis.com/maps/api/geocode/json"
        let latlng = "\(lat),\(lng)"
        let apiKey = "AIzaSyCRymVmfMFKrVCT3fn1El_KDQKSWA4rErQ"
        
        return "\(baseURL)?latlng\(latlng)key=\(apiKey)"
    }
}




