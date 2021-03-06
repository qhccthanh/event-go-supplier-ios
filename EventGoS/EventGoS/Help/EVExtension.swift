//
//  EVExtension.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import MBProgressHUD
import UIKit
import Toaster

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

fileprivate var toast: Toast!

extension Toast {
    
    class func show(_ mesage: String, duration: TimeInterval = Delay.short) {
        if toast != nil {
            toast.cancel()
        }
        toast = Toast.init(text: mesage, duration: duration)
        toast.show()
    }
}

extension UIAlertController {
    class func showAlert(_ message: String,title: String,sender: UIViewController, doneAction: ( () -> Void )? = nil, cancelAction: ( () -> Void )? = nil) {
        DispatchQueue.main.async(execute: {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                doneAction?()
            }
            alert.addAction(okAction)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {
                action -> Void in
                cancelAction?()
            }
            alert.addAction(cancelAction)
            sender.present(alert, animated: true, completion: { () in  })
        })
    }
}

