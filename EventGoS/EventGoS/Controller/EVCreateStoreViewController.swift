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
import CPImageViewer
import MBProgressHUD
import Toaster
import RxCocoa
import RxSwift
import STPopup

class EVCreateStoreViewController: UIViewController {
    
    @IBOutlet weak var nameInputView: AnimatedTextInput!
    @IBOutlet weak var detailInputView: AnimatedTextInput!
    @IBOutlet weak var addressInputView: AnimatedTextInput!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    dynamic var images: [EVImageResource] = []
    var locationLoaded: CLLocation?
    dynamic var currentGeocode: EVGeocode?
    
    var popupMapController: STPopupController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        locationManager.delegate = self
        locationManager.distanceFilter = 2
        updateLocation()
        setupObserve()
        
        _ = self.rx.observe(EVGeocode.self, "currentGeocode")
        .subscribe(onNext: {
            [weak self] (geocode) in
            if let geocode = geocode {
                self?.addressInputView.text = geocode.formatted_address
                self?.updateDateLabel.text = CTDateFormart().fullString()
            }
            
            self?.showMapButton.isEnabled = self?.currentGeocode != nil
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isMovingToParentViewController {
            MBProgressHUD.showHUDLoading()
            _ = Observable<Any>.empty().delay(2,scheduler: MainScheduler.instance)
                .subscribe(onCompleted: {
                    MBProgressHUD.hideHUDLoading()
                    self.getAddresInfo()
                })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.view.endEditing(true)
    }
    
    func setupObserve() {
        
        guard  let nameTextField = nameInputView.textInput as? UITextField,
            let detailTextView = detailInputView.textInput as? UITextView,
            let addressTextView = addressInputView.textInput as? UITextView else {
            
            return
        }
        
        let nameObser = nameTextField.rx.text.orEmpty.asObservable()
        let detailObser = detailTextView.rx.text.orEmpty.asObservable()
        let addressObser = addressTextView.rx.text.orEmpty.asObservable()
        let geocodeObser = self.rx.observe(EVGeocode.self, "currentGeocode")
        let imageObser = self.rx.observe([EVImageResource].self, "images")
        
        _ = Observable.combineLatest(
            nameObser,
            detailObser,
            addressObser,
            geocodeObser,
            imageObser
            ).subscribe(onNext: {
                [weak self] (name,detail,address,geocodeT,imagesT) in
                
                let enable = name.characters.count < 5 ||
                    detail.characters.count < 5 ||
                    address.characters.count < 5 ||
                    geocodeT == nil ||
                    imagesT == nil ||
                    (imagesT != nil && imagesT!.count == 0)
                
                self?.doneButton.isEnabled = !enable
        })
        
    }
    
    func setupView() {
        nameInputView.placeHolderText = "Tên Cửa Hàng"
        detailInputView.placeHolderText = "Mô tả cửa hàng"
        detailInputView.type = .multiline
        addressInputView.placeHolderText = "Địa chỉ cửa hàng"
        addressInputView.type = .multiline
    }
    
    
    @IBAction func onPostAction(_ sender: Any) {
        
        self.view.endEditing(true)
        MBProgressHUD.showHUDLoading()
        
        let location = EVLocation().build {
            $0.name = nameInputView.text!
            $0.detail = detailInputView.text!
            $0.address = addressInputView.text!
            $0.location_info = currentGeocode!
            $0.image_url = images.map({
                return $0.url
            })
        }
        
        _ = EVLocationService
            .createSupplierLocation(location)
            .subscribe(onNext: {
                [weak self] (location) in
                
                MBProgressHUD.hideHUDLoading()
                EVSupplier.current?.locations.insert(location, at: 0)
                self?.navigationController?.popViewController(animated: true)
                
                Toast.show("Tạo cửa hàng thành công")
            }, onError: {
                error in
                
                MBProgressHUD.hideHUDLoading()
                print(error)
                Toast.show("Tạo cửa hàng thất bại")
            })
    }
    
    @IBAction func onDefineMyLocationAction(_ sender: Any) {
        
        getAddresInfo()
    }
    
    @IBAction func onViewInMap(_ sender: Any) {
        
        guard let geocode = currentGeocode else {
            Toast.show("Bạn chưa được định vị. Vui lỏng định vị")
            return
        }
        
        let mapController = EVMapPopupViewController()
        mapController.geocode = geocode
        popupMapController = STPopupController(rootViewController: mapController)
        popupMapController.backgroundView?
            .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        popupMapController.present(in: self)
    }
    
    func dismissPopup() {
        
        if let pop = popupMapController {
            pop.dismiss()
        }
    }
    
    func checkPermission() {
        
        let status = CLLocationManager.authorizationStatus()
        
        if status != .authorizedWhenInUse {
            // request open location
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            // request open location service
            
            return
        }
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func getAddresInfo() {
        
        guard let location = self.locationLoaded else {
            Toast.show("Bạn chưa có toạ độ vui lòng kiểm tra lại")
            return
        }
        
        MBProgressHUD.showHUDLoading()
        let loadAddress = EVLocationService.getLocationInfo(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        
        _ = loadAddress.subscribe(onNext: {
            (geocodes) in
            MBProgressHUD.hideHUDLoading()
            if let geocode = geocodes.first {
                self.currentGeocode = geocode
            }
        }, onError: {
            error in
            MBProgressHUD.hideHUDLoading()
            print(error)
        })
    }
    
}

extension EVCreateStoreViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageStoreCell", for: indexPath) as! EVImageStoreCell
        let image = images[indexPath.row - 1]
        cell.delegate = self
        cell.bindingUI(image)
        
        return cell
    }
    
}

extension EVCreateStoreViewController: EVImageStoreCellDelegate {
    
    func didPressed(at cell: EVImageStoreCell, item: EVImageResource) {
        
        let controller = CPImageViewerViewController()
        controller.transitioningDelegate = CPImageViewerAnimator()
        controller.image = cell.mainImageView.image
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func didLongPress(at item: EVImageResource) {
        
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
        
        if indexPath.row == 0 {
            let imageVC = EVController.images.getController() as! EVImagesViewController
            
            imageVC.selectedBlock = {
                images in
                
                self.images = images
                self.imageCollectionView.reloadData()
            }
            
            self.navigationController?.pushViewController(imageVC, animated: true)
        }
        
        return false
    }
}

extension EVCreateStoreViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationLoaded = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

