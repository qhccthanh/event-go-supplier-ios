//
//  EVInfoStoreViewController.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/17/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import AnimatedTextInput
import DKImagePickerController
import CoreLocation

class EVCreateStoreViewController: UIViewController {
    
    @IBOutlet weak var nameInputView: AnimatedTextInput!
    @IBOutlet weak var detailInputView: AnimatedTextInput!
    @IBOutlet weak var addressInputView: AnimatedTextInput!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var locationManager = CLLocationManager()
    var images: [EVImageResource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        nameInputView.placeHolderText = "Tên Cửa Hàng"
        detailInputView.placeHolderText = "Mô tả cửa hàng"
        addressInputView.placeHolderText = "Địa chỉ cửa hàng"
    }
    
    
    @IBAction func onPostAction(_ sender: Any) {
        
        
    }
    
    @IBAction func onDefineMyLocationAction(_ sender: Any) {
        
        
    }
    
}

extension EVCreateStoreViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageStoreCell", for: indexPath) as! EVImageStoreCell
        let image = images[indexPath.row]
        cell.bindingUI(image)
        
        return cell
    }
    
    
}

extension EVCreateStoreViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return imageSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 {
            let imageVC = EVController.images.getController() as! EVImagesViewController
            
            imageVC.selectedBlock = {
                images in
                
                self.images = images
                self.imageCollectionView.reloadSections(IndexSet.init(integer: 1))
            }
            
            self.navigationController?.pushViewController(imageVC, animated: true)
        }
        
        return false
    }
}

extension EVCreateStoreViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

