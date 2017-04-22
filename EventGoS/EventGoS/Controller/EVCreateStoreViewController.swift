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
import GooglePlaces
import GoogleMaps

class EVCreateStoreViewController: UIViewController {
    
//    @IBOutlet weak var nameStoreView: AnimatedTextInput!
//    @IBOutlet weak var infoSupplierView: AnimatedTextInput!
//    @IBOutlet weak var openTime: AnimatedTextInput!
//    @IBOutlet weak var closeTime: AnimatedTextInput!
//    @IBOutlet weak var address: AnimatedTextInput!
//    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let reuseIdentifier = "cell"
    var listImageSelected:Array<UIImage> = Array<UIImage>()
    var listImageStore: Array<EVImageResource> = Array<EVImageResource>()
    var didFindMyLocation = false
    var locationManager = CLLocationManager()
    var alreadyUpdatedLocation = false
//    let ev: EVImagesViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        alreadyUpdatedLocation = false
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
      
//        ev?.delegate = self
    }
    
    func setupView(){
        self.title = "ADD STORE"
//        nameStoreView.placeHolderText = "Tên Cửa Hàng"
//        infoSupplierView.placeHolderText = "Cửa Hàng Trưởng"
//        openTime.placeHolderText = "Giờ mở cửa"
//        closeTime.placeHolderText = "Giờ đóng cửa"
//        latitude.placeHolderText = "Kinh độ"
//        longitude.placeHolderText = "Vĩ độ"
//        address.placeHolderText = "Địa chỉ"
//        listImageSelected.append( EVImage.ic_add_place.icon())
//        collectionView.delegate = self
//        collectionView.dataSource = self
        listImageStore.append(EVImageResource(name: "add", image: EVImage.ic_add_place.icon()))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostAction(_ sender: Any) {
        
//        let image: ImageStore = ImageStore(name: "123", image: listImageSelected[0])
//        EVImageServices.shareInstance.uploadImage(imageStore: image, callback: <#(ImageStore) -> Void#>)
    }
    
    @IBAction func onDefineMyLocationAction(_ sender: Any) {
//        if locationManager.locationServicesEnabled {
//            if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
//                manager.requestWhenInUseAuthorization()
//            } else {
//                startUpdatingLocation()
//            }
//        }
    }

}
extension EVCreateStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return listImageSelected.count
        
        if section == 0 {
            return listImageStore.count
        }else {
            return listImageSelected.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVInfoStoreCollectionViewCell else {return}
        
        if (indexPath.section == 0 && indexPath.row == 0) {
//            self.navigationController?.pushViewController(ev!, animated: true)
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVInfoStoreCollectionViewCell {
            
            if indexPath.section == 0 {
            let model = listImageStore[indexPath.row]
                if let url = URL(string: model.url.replacingOccurrences(of: "\"", with: "")){
                    cell.imageInfoStore.downloadedFrom(url: url)
                }
            }
            if indexPath.section == 1 {
                cell.imageInfoStore.image = listImageSelected[indexPath.row]
            }
            return cell
        }
        
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumInteritemSpacing = 2
            let spacePadding = itemsPerRow * flow.minimumInteritemSpacing
            let widthAvailable = self.view.bounds.width - spacePadding
            let widthItem: CGFloat = widthAvailable/itemsPerRow
            if (widthItem >= 100) {
                return CGSize(width: widthItem, height: widthItem)
            }
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension EVCreateStoreViewController: CLLocationManagerDelegate{
    
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
        if alreadyUpdatedLocation == false {
            if let location = locations.first {
                locationManager.stopUpdatingLocation()
                alreadyUpdatedLocation = true
                
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                    if error != nil {
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                    }
                    
                    if (placeMarks?.count)! > 0 {
                        
                        if let placeMark = placeMarks!.first {
                            //                            infoAddress.county = placeMark.country ?? ""
                            //                            infoAddress.postCode = placeMark.postalCode ?? ""
                            //                            infoAddress.streetNumber = placeMark.subThoroughfare ?? ""
                            //                            infoAddress.state = placeMark.administrativeArea ?? ""
                            //                            infoAddress.route = placeMark.thoroughfare ?? ""
                            //                            infoPlace.addressPlace = infoAddress
                            //                            DispatchQueue.main.async {
                            //                                if infoAddress.streetNumber.isEmpty {
                            //                                    self.addressBusinessTextField.text = "Address invalide"
                            //                                    self.autocompleteController.showMessageForUser(with: "Please choose address number")
                            //                                } else {
                            //                                    self.placePost = infoPlace
                            //                                    self.addressBusinessTextField.text = infoPlace.addressPlace.address
                            //                                    self.dismiss(animated: true, completion: nil)
                            //                                }
                            //
                            //
                            print(placeMark)
                        }
                    }
                    
                })
            }
        }
    }
    
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
        
    }
}

//extension EVInfoStoreViewController : EVSelected {
//    func imageSelected(listImageUpload: Array<UIImage>?, listImageStore: Array<EVImageResource>?) {
//        if listImageUpload?.count != 0{
//            listImageSelected.append(contentsOf: listImageUpload!)
//        }
//        
//        if listImageStore?.count != 0 {
//            self.listImageStore.append(contentsOf: listImageStore!)
//        }
//        
//        self.collectionView.reloadData()
//    }
//}

