//
//  Constants.swift
//  EventGo-iOSApp
//
//  Created by Quach Ha Chan Thanh on 3/22/17.
//  Copyright © 2017 Quach Ha Chan Thanh. All rights reserved.
//

import Foundation


struct EVConstant {
    
    static let version: String = "1.0"
    static let API_GOOGLE_MAP_KEY: String = "AIzaSyC6U8rmpCbXfW7kSkoxNks82zmIJpAOxS8"
    static let API_GOOGLE_MAP_SERVICE_KEY: String = "AIzaSyCRymVmfMFKrVCT3fn1El_KDQKSWA4rErQ"
    static let BASE_URL_STRING: String = ""
    static let BASE_URL: URL = URL(string: EVConstant.BASE_URL_STRING)!
    static let isDebug: Bool = false
    static let PROVIDER_FACEBOOK:String = "facebook"
    static let PROVIDER_GOOGLE:String = "google"
}

let ONCE_DAY_INTERVAL: TimeInterval = 24 * 60 * 60
