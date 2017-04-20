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
