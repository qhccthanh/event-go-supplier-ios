//
//  EVLoginController.swift
//  EventGoS
//
//  Created by thanhqhc on 4/14/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toaster

class LoginEVCoordinator: LoginCoordinator {
    
    // MARK: - LoginCoordinator
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    // MARK: - Setup
    
    // Customize LoginKit. All properties have defaults, only set the ones you want.
    func configureAppearance() {
        // Customize the look with background & logo images
//        backgroundImage = #imageLiteral(resourceName: "Background")
        mainLogoImage = #imageLiteral(resourceName: "EventGo-Logo")
        secondaryLogoImage = #imageLiteral(resourceName: "EventGo-Logo")
        
        // Change colors
        tintColor = UIColor(red: 0, green: 150.0/255, blue: 136.0/255, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Đăng nhập"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = ""
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "Tên tài khoản"
        passwordPlaceholder = "Mật khẩu"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    // Handle login via your API
    override func login(email: String, password: String) {
        
        if email.characters.count < 5 || password.characters.count < 5 {
            Toast.show("Vui lòng nhập đẩy đủ tài khoản hoặc password")
            return
        }
        
        if email.contains(">") || email.contains("<") || password.contains(">") || password.contains("<") {
            Toast.show("Ô không thể chứa các ký tự đặt biệt")
            return
        }
        
        MBProgressHUD.showHUDLoading()
        print("Login with: email =\(email) password = \(password)")
        
        _ = EVLoginAPI.signinWith(username: email, password: password).subscribe(onNext: {
            _ in
            MBProgressHUD.hideHUDLoading()
            EVMainViewController.showMainSupplierController()
        }, onError: { (error) in
            MBProgressHUD.hideHUDLoading()
            
            Toast.show("Đăng nhập thất bại")
        })
    }
    
    // Handle signup via your API
    override func signup(name: String, email: String, password: String) {
        print("Signup with: name = \(name) email =\(email) password = \(password)")
        
    }
    
    
    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        print("Recover password with: email =\(email)")
    }
    
}
