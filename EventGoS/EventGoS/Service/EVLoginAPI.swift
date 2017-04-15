//
//  EVLoginAPI.swift
//  EventGoS
//
//  Created by thanhqhc on 4/14/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import ReactiveSwift
import Alamofire

let kBaseUrl = "https://evgo.herokuapp.com/api/v1.0/"

enum EVSupplierAPI: String {
    
    case login = "suppliers/signin"
    case me = "suppliers/me"
    case location = "locations"
    
    func path() -> String {
        return kBaseUrl.appending(self.rawValue)
    }
}

class BaseService {
    
    internal var headers : [String : String] {
        get {
            return ["Content-Type": "application/json"]
        }
    }

    fileprivate var _sessionManager: SessionManager!
    internal var sessionManager : SessionManager {
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

class EVLoginAPI: BaseService {
    internal static let shareInstance = EVLoginAPI()
    func signinWith(username: String, password: String){
        var params = Dictionary<String, Any>()
        params["username"] = username
        params["password"] = password
        sessionManager.request(EVSupplierAPI.login.path(), method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.headers).responseJSON { (respone) in
            print(respone)
        }
    }
    
    func checkLogin() {
        
    }
}
