//
//  EVExtension.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import MBProgressHUD
import UIKit

extension MBProgressHUD {
    
    class func showHUDLoading(_ view: UIView = UIApplication.shared.keyWindow!) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Đang xữ lý vui lòng chờ ..."
        hud.mode = .indeterminate
    }
    
    class func hideHUDLoading(_ view: UIView = UIApplication.shared.keyWindow!) {
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
}

extension Date {
    
    static var js_StringFormart: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter
    }()
    
    static func fromStringDate(_ string: String) -> Date {
        
        let dateFormatter = Date.js_StringFormart
        let date = dateFormatter.date(from: string)!
        
        return date
    }
}

