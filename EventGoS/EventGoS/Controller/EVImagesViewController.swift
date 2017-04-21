//
//  EVListImageStoreCollectionViewController.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import DKImagePickerController
import MBProgressHUD
import RxSwift
import CPImageViewer

fileprivate let reuseIdentifier = "ImageStoreCell"
fileprivate let cellWidth = (UIScreen.main.bounds.width - 4) / 3 - 2
fileprivate let imageSize = CGSize(width: cellWidth, height: cellWidth * 1.25)

class EVImagesViewController: UIViewController, CPImageControllerProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var animationImageView: UIImageView!
    
    lazy var pickerController: DKImagePickerController = {
        return DKImagePickerController()
    }()

    
    var selectedBlock: ((_ images: EVImageResource) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if EVSupplier.current?.images.count == 0 {
            loadData()
        }
        
        _ = EVSupplier.current!.rx.observe([EVImageResource].self, "images")
            .subscribe(onNext: {
                [weak self] (_) in
                dispatch_main_queue_safe {
                    self?.collectionView.reloadData()
                }
        })
        
        collectionView.contentInset = UIEdgeInsetsMake(8, 2, 8, 2)
    }
    
    func loadData() {
        
        _ = EVImageServices.getAllSupplierImage().subscribe(onNext: { (images) in
//            print(images)
        })
    }
    
    func showImagePickerController(_ picker: DKImagePickerController) {
        picker.deselectAllAssets()
        
        picker.allowsLandscape = false
        picker.maxSelectableCount = 5
        picker.assetGroupTypes = [
            .smartAlbumUserLibrary,
            .smartAlbumFavorites,
            .albumRegular
        ]
        picker.assetType = .allPhotos
        picker.autoDownloadWhenAssetIsInCloud = false
        picker.didSelectAssets = {
            [unowned self] assets in
            self.uploadImage(assets)
        }
        
        self.navigationController?.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(_ assets: [DKAsset]) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .determinateHorizontalBar
        var currentCompleteCount: Float = 0
        hud.progress = 0
        hud.label.text = "Đang tải hình ảnh lên máy chủ \(Int(currentCompleteCount))/\(assets.count)"
        
        _ = EVImageUploadManager.uploadImage(assets)
            .subscribe(onNext: { (image) in
                
                currentCompleteCount += 1
                hud.progress = (currentCompleteCount / Float(assets.count)) / 100
                hud.label.text = "Đang tải hình ảnh lên máy chủ \(Int(currentCompleteCount))/\(assets.count)"
                
                EVSupplier.current?.images.insert(image, at: 0)
                
                if Int(currentCompleteCount) == assets.count {
                    hud.hide(animated: true)
                }
            }, onError: { (error) in
                print(error)
                hud.hide(animated: true)
            })
    }
    
    @IBAction func addImage(_ sender: AnyObject!) {
        showImagePickerController(self.pickerController)
    }
}

extension EVImagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EVSupplier.current?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EVImageStoreCell
        let item = EVSupplier.current!.images[indexPath.row]
        cell.bindingUI(item)
        
        return cell
    }
    
}

extension EVImagesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EVImageStoreCell {
            self.animationImageView = cell.mainImageView
            
            let controller = CPImageViewerViewController()
            controller.transitioningDelegate = CPImageViewerAnimator()
            controller.image = animationImageView.image
            self.present(controller, animated: true, completion: nil)
        }
    }
}

