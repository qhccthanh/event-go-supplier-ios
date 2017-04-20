//
//  EVMenuViewController.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import MBProgressHUD

class EVMenuViewController: QuickTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableContents = [
            Section(title: nil, rows: [
                NavigationRow(title: "Địa điểm", subtitle: .belowTitle("Danh sách thông tin địa điểm của hệ thống"), icon: Icon(image: #imageLiteral(resourceName: "ic_location")), action: { (_) in
                    let storeInfo = EVController.infoStore.getController()
                    self.navigationController?.pushViewController(storeInfo, animated: true)
                }),
                NavigationRow(title: "Hỉnh ảnh", subtitle: .belowTitle("Hình ảnh của hệ thống"), icon: Icon(image: #imageLiteral(resourceName: "ic_picture")), action: { (_) in
                    let imagesInfo = EVImagesViewController()
                    self.navigationController?.pushViewController(imagesInfo, animated: true)
                }),
            ]),
            Section(title: nil, rows: [
                TapActionRow(title: "Đăng xuất", action: {
                    _ in
                    
                    MBProgressHUD.showHUDLoading()
                    _ = EVLoginAPI.signOut().subscribe(onNext: {
                        bool in
                        
                        MBProgressHUD.hideHUDLoading()
                        if bool {
                            UIApplication.shared.keyWindow?.rootViewController = EVController.root.getController()
                        }
                    })
                })
            ])
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Event Go"
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_help"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(helpAction))
        self.navigationItem.rightBarButtonItems = [barButton]
    }
    
    func helpAction() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}