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

enum EVResult: String {
    case success
    case faillure
}

enum EVImage: String {
    
    case backgroundColor = "backgroundColor"
    case ic_add_place = "ic_add_place"
    case ic_dontCheck = "ic_dontCheck"
    case ic_checked = "ic_checked"
}

extension EVImage {
    
    func icon() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

enum EVController: String {

//    case viewController = "EVViewController"
//    case logIn = "EVLogInViewController"
//    case mainGame = "EVMainGameController"
//    case defaultVC = "EVDefaultControllerViewController"
//    case userInfo = "EVUpdateUserInfoViewController"
//    case popOver = "EVPopOverController"
//    case home = "EVHomeViewController"
    case infoStore = "EVInfoStoreViewController"
    case listImageStore = "EVListSupplierImageCollectionViewController"
    case main = "EVSupplierMainController"
    case root = "EVMainViewController"
    case stores = "EVStoresViewController"
    case images = "EVImagesViewController"
}
extension EVController {
    
    func getController() -> UIViewController {
        let controller = StoryBoard.Main.viewController(self.rawValue)
        return controller 
    }
    
    func showController(_ inController: UIViewController) {
        dispatch_main_queue_safe {
            let vc = self.getController()
            inController.present(vc, animated: true, completion: nil)

        }
    }
}
