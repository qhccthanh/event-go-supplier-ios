//
//  ViewController.swift
//  EventGoS
//
//  Created by thanhqhc on 4/14/17.
//  Copyright © 2017 VNG Corporation. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import MBProgressHUD

class EVMainViewController: UIViewController {

    lazy var loginCoordinator: LoginEVCoordinator = {
        return LoginEVCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0, green: 150.0/255, blue: 136.0/255, alpha: 1)
        
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(120)
        }
        imageView.ev_cornerRadius = 32
        imageView.image = #imageLiteral(resourceName: "EventGo-Logo")
        
        let nameAppLabel = UILabel()
        nameAppLabel.textColor = .white
        nameAppLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameAppLabel.text = "Event Go Supplier"
        self.view.addSubview(nameAppLabel)
        
        nameAppLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MBProgressHUD.showHUDLoading(self.view)
        _ = EVLoginAPI.checkLogin().subscribe(onNext: {
            supplier in
            print(supplier)
            MBProgressHUD.hideHUDLoading()
            
            EVMainViewController.showMainSupplierController()
        }, onError: {
            error in
            print(error)
            self.showLogin()
            MBProgressHUD.hideHUDLoading()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        loginCoordinator.start()
    }
    
    func showLogin() {
        loginCoordinator.start()
    }
    
    class func showMainSupplierController() {
        
        let nav = EVController.main.getController() as! UINavigationController
        let mainMenuController = EVMenuViewController()
        nav.setViewControllers([mainMenuController], animated: true)
        
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
}

