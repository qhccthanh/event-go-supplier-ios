//
//  EVInfoStoreViewController.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/17/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import AnimatedTextInput


class EVInfoStoreViewController: UIViewController {
    
    @IBOutlet weak var nameStoreView: AnimatedTextInput!
    @IBOutlet weak var infoSupplierView: AnimatedTextInput!
    @IBOutlet weak var openTime: AnimatedTextInput!
    @IBOutlet weak var closeTime: AnimatedTextInput!
    @IBOutlet weak var latitude: AnimatedTextInput!
    @IBOutlet weak var longitude: AnimatedTextInput!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let reuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        nameStoreView.placeHolderText = "Tên Cửa Hàng"
        infoSupplierView.placeHolderText = "Cửa Hàng Trưởng"
        openTime.placeHolderText = "Giờ mở cửa"
        closeTime.placeHolderText = "Giờ đóng cửa"
        latitude.placeHolderText = "Kinh độ"
        longitude.placeHolderText = "Vĩ độ"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension EVInfoStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 //listImageSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVInfoStoreCollectionViewCell else {
            
            return
        }
        
//        if (indexPath.row == 0) {
//            
//            let pickerController = DKImagePickerController()
//            listImageSelected.removeAll()
//            listImageSelected.append(UIImage(named: "ic_add_place")!)
//            pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                for imageData in assets {
//                    imageData.fetchOriginalImage(false, completeBlock: { ( image, into) in
//                        if let image = image {
//                            
//                            self.listImageSelected.append(image)
//                            self.collectionView.reloadData()
//                        }
//                    })
//                }
//                
//            }
//            
//            self.present(pickerController, animated: true) {}
//        }
//        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVInfoStoreCollectionViewCell {
//            cell.selectedImageView.image = listImageSelected[indexPath.row]
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

