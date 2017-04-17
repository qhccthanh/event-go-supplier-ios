//
//  Marco.swift
//  EventGo-iOSApp
//
//  Created by Quach Ha Chan Thanh on 3/21/17.
//  Copyright © 2017 Quach Ha Chan Thanh. All rights reserved.
//

import Foundation

func dispatch_main_queue_safe(_ excute: @escaping () -> Void) {
    
    if Thread.isMainThread {
        excute()
        return
    }
    
    DispatchQueue.main.async { 
        excute()
    }
}

//extension UIDevice {
//    
//    class func ev_isIPad() -> Bool {
//        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
//    }
//    
//    class func ev_isIPhone() -> Bool {
//        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
//    }
//    
//    class func ev_version() -> Float {
//        return Float(UIDevice.current.systemVersion)!
//    }
//    
//    class func ev_iPhone() -> String {
//        return "iPhone"
//    }
//    
//    class func ev_iPad() -> String {
//        return "iPad"
//    }
//    
//    class func ev_model() -> String {
//        return UIDevice.current.model
//    }
//    
//    class func ev_localized() -> String {
//        return UIDevice.current.localizedModel
//    }
//    
//    class func ev_name() -> String {
//        return UIDevice.current.name
//    }
//    
//    class func ev_orientation() -> UIDeviceOrientation {
//        return UIDevice.current.orientation
//    }
//    
//    class func ev_simulator() -> String {
//        return "Simulator"
//    }
//    
//}
//
//var SCREEN_WIDTH_PORTRAIT: CGFloat = UIScreen.main.bounds.size.width
//var SCREEN_HEIGHT_PORTRAIT: CGFloat = UIScreen.main.bounds.size.height
//var SCREEN_WIDTH_LANDSCAPE: CGFloat =  UIScreen.main.bounds.size.height
//var SCREEN_HEIGHT_LANDSCAPE: CGFloat = UIScreen.main.bounds.size.width
//
//var SCREEN_SIZE: CGSize = UIScreen.main.bounds.size
//
//var SCREEN_FRAME_PORTRAIT: CGRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH_PORTRAIT, height: SCREEN_HEIGHT_PORTRAIT)
//var SCREEN_FRAME_LANDSCAPE: CGRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH_LANDSCAPE, height: SCREEN_HEIGHT_LANDSCAPE)
//
//var SCREEN_SCALE: CGFloat = UIScreen.main.scale
//
//let SCREEN_SIZE_PORTRAIT: CGSize = CGSize(width: SCREEN_WIDTH_PORTRAIT * SCREEN_SCALE ,
//                                          height: SCREEN_HEIGHT_PORTRAIT * SCREEN_SCALE )




