//
//  EVListStoreTableViewController.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/17/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ESPullToRefresh
import Toaster

class EVStoresViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if EVSupplier.current?.locations.count == 0 {
            loadData()
        }
        
        _ = EVSupplier.current!.rx.observe([EVLocation].self, "locations")
            .subscribe(onNext: {
                [weak self] (_) in
                dispatch_main_queue_safe {
                    self?.tableView.reloadData()
                }
        })
        
        self.tableView.es_addPullToRefresh {
            [weak self] in
            self?.loadData()
        }
    }
    
    func loadData() {
        _ = EVLocationService.getAllSupplierLocation()
            .subscribe(onNext: {
            [weak self] _ in
            
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            }, onError: {
                [weak self] _ in
                
                self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                Toast.show("Tải dữ liệu thất bại vui lòng kiểm tra lại")
        })
    }
    
    @IBAction func addLocation(_ sender: AnyObject!) {
        
        let createStoreController = EVController.createStore.getController()
        self.navigationController?.pushViewController(createStoreController, animated: true)
    }
}

extension EVStoresViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EVSupplier.current?.locations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell")!
        let location = EVSupplier.current!.locations[indexPath.row]
        
        if let imageView = cell.contentView.viewWithTag(101) as? UIImageView,
            let imageString = location.image_url, let imageURL = URL(string: imageString)
        {
            imageView.setImageWithUrl(imageURL, placeHolderImage: #imageLiteral(resourceName: "AppIcon"))
        }
        
        if let nameLabel = cell.contentView.viewWithTag(102) as? UILabel {
            nameLabel.text = location.name
        }
        
        if let addressLabel = cell.contentView.viewWithTag(103) as? UILabel {
            addressLabel.text = location.address
        }
        if let detailLabel = cell.contentView.viewWithTag(104) as? UILabel {
            detailLabel.text = location.detail
        }
        if let createDataLabel = cell.contentView.viewWithTag(105) as? UILabel {
            createDataLabel.text = location.created_date.toString()
        }
        
        return cell
    }
}

extension EVStoresViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
    }
}
