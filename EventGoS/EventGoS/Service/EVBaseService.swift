//
//  EVBaseService.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/20/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import Foundation
import Alamofire

let kDebugUrl = "http://localhost:3000/api/v1.0/"
let kMainUrl = "https://evgo.herokuapp.com/api/v1.0/"
let kBaseUrl = kDebugUrl

enum EVSupplierAPI: String {
    
    case login = "staff/signin"
    case me = "staff/me"
    case logout = "staff/signout"
    case locations = "staff/locations"
    case image = "staff/images"
    
    func path() -> String {
        return kBaseUrl.appending(self.rawValue)
    }
}

class BaseService {
    
    static var headers : [String : String] {
        get {
            return [
                "Content-Type": "application/json",
                "withCredentials": "true"
            ]
        }
    }
    
    fileprivate static var _sessionManager: SessionManager!
    static var sessionManager : SessionManager {
        if _sessionManager == nil {
            let requestTimeout: TimeInterval = 60
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = requestTimeout
            
            _sessionManager = SessionManager(configuration: configuration)
            _sessionManager.delegate.sessionDidReceiveChallenge = { session, challenge in
                var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
                var credential: URLCredential?
                
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                    disposition = .useCredential
                    credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                } else {
                    if challenge.previousFailureCount > 0 {
                        disposition = .cancelAuthenticationChallenge
                    } else {
                        credential = self._sessionManager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                        
                        if credential != nil {
                            disposition = .useCredential
                        }
                    }
                }
                
                return (disposition, credential)
            }
        }
        return _sessionManager
    }
}
