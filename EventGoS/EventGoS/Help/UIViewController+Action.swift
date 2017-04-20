//
//  UIViewController+Action.swift
//  QuanLyChiTieu
//
//  Created by Quach Ha Chan Thanh on 11/16/16.
//  Copyright © 2016 Quach Ha Chan Thanh. All rights reserved.
//

import Foundation


extension UIViewController {
    
    @IBAction func popAction(_ sender: AnyObject!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissViewControllerAction(_ sender: AnyObject!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissNavigationAction(_ sender: AnyObject!) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
