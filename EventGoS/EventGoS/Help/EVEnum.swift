//
//  EVEnum.swift
//  EventGo-iOSApp
//
//  Created by Nguyen Xuan Thai on 4/10/17.
//  Copyright © 2017 Quach Ha Chan Thanh. All rights reserved.
//

import Foundation
import UIKit
enum EVCheckUserEnumType: String {
    case login
    case notLogin
    case updatedInfo
}

enum EVUpdateResult: String {
    case success
    case faillure
}

enum EVImage: String {
    
    case backgroundColor = "backgroundColor"
    case ic_distance = "ic_distance"
    case ic_email = "ic_email"
    case ic_facebook = "ic_facebook"
    case ic_google = "ic_google"
    case ic_pagoda = "ic_pagoda"
    case ic_phone = "ic_phone"
    case ic_quit = "ic_quit"
    case ic_user = "ic_user"
    case ic_logo = "ic_logo"
    case ic_back = "ic_back"
    case ic_check = "ic_check"
    case ic_checklist = "ic_checklist"
    case ic_bag = "ic_bag"
    case ic_package = "ic_package"
    case ic_run = "ic_run"
}

extension EVImage {
    
    func icon() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

enum EVController: String {

    case viewController = "EVViewController"
    case logIn = "EVLogInViewController"
    case mainGame = "EVMainGameController"
    case defaultVC = "EVDefaultControllerViewController"
    case userInfo = "EVUpdateUserInfoViewController"
    case popOver = "EVPopOverController"
    case home = "EVHomeViewController"
    
}
extension EVController {
    
    func getController() -> UIViewController {
        let controller = StoryBoard.DemoST.viewController(self.rawValue)
        return controller as! UIViewController
    }
    
    func showController(_ inController: UIViewController) {
        dispatch_main_queue_safe {
            let vc = self.getController()
            inController.present(vc, animated: true, completion: nil)

        }
    }
}
