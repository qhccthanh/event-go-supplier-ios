//
//  EVListImageStoreCollectionViewController.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import DKImagePickerController
import AlamofireImage

private let reuseIdentifier = "cell"

protocol EVSelected : class {
    func imageSelected(listImageUpload: Array<UIImage>?, listImageStore: Array<ImageStore>?)
}

class EVListSupplierImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var listSupplierImage: Array<ImageStore> = Array<ImageStore>()
    var listImageSelected: Array<UIImage> = Array<UIImage>()
    weak var delegate: EVSelected?
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.title = "WRITE POST"
        let rightButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        self.navigationItem.rightBarButtonItem = rightButton
        listImageSelected.append(EVImage.ic_add_place.icon())
        // Do any additional setup after loading the view.
    }
    
    @objc private func doneAction() {
       
        listImageSelected.remove(at: 0)
        var arrayImage = Array<ImageStore>()
        for image in listSupplierImage {
            if image.isChecked == true {
                arrayImage.append(image)
            }
        }
        guard listImageSelected.count != 0 || arrayImage.count != 0 else {
            return
        }
        
//        if listImageSelected.count >= 1 {
//            listImageSelected.remove(at: 0)
//        }
        delegate?.imageSelected(listImageUpload: listImageSelected, listImageStore: arrayImage)
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EVImageServices.shareInstance.getAllSupplierImage { (result) in
            
            if let result = result {
                self.listSupplierImage = result.listImage
            }
            
            dispatch_main_queue_safe {
                self.collectionView?.reloadData()
            }
        }
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.listSupplierImage.count
        } else {
            return self.listImageSelected.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? EVInfoStoreCollectionViewCell else {
            
            return
        }
        
        if indexPath.section == 0 {
            var model = listSupplierImage[indexPath.row]
            if model.isChecked == false {
                cell.imageSelectedView.image = UIImage(named: "ic_checked")
                listSupplierImage[indexPath.row].isChecked = true
            } else {
                listSupplierImage[indexPath.row].isChecked = false
                cell.imageSelectedView.image = EVImage.ic_dontCheck.icon()
            }
            self.collectionView?.reloadData()
        }
        
        if indexPath.section == 1 {
            if (indexPath.row == 0) {
                
                let pickerController = DKImagePickerController()
               
                pickerController.didSelectAssets = { (assets: [DKAsset]) in
                    // MBProgessHUD
                    self.listImageSelected.removeAll()
                    self.listImageSelected.append(EVImage.ic_add_place.icon())
                    for imageData in assets {
                        imageData.fetchOriginalImage(false, completeBlock: { ( image, into) in
//                            self.collectionView?.reloadSections(NSIndexSet(index: 1) as IndexSet)
                            
                            self.listImageSelected.append(image!)
                            self.collectionView?.reloadData()
                        })
                    }
                    
                    EVImageUploadManager.manager.uploadImage(assets, progressBlock: { (index) in
                        
                    }, successBlock: { (imageStores) in
                        print(imageStores)
//                        self.listImageSelected = imageStores
                    })
                }
                
                self.present(pickerController, animated: true) {}
            }

        }
    }
//
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EVInfoStoreCollectionViewCell {
            if indexPath.section == 0 {
                let model = listSupplierImage[indexPath.row]
                cell.imageSelectedView.image = EVImage.ic_checked.icon()
                if let url = URL(string: model.url.replacingOccurrences(of: "\"", with: "")){
                    cell.imageInfoStore.downloadedFrom(url: url)
                }
            } else {
                cell.imageInfoStore.image = self.listImageSelected[indexPath.row]
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
