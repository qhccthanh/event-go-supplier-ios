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
import XLActionController
import Toaster
import ESPullToRefresh

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
        
        self.collectionView.contentInset = UIEdgeInsetsMake(8, 2, 8, 2)
        self.collectionView.es_addPullToRefresh {
            [weak self] in
            self?.loadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            EVSupplier.current?.images.forEach({
                $0.isChecked = false
            })
        }
    }
    
    func loadData() {
        
        _ = EVImageServices.getAllSupplierImage().subscribe(onNext: {
            [weak self] _ in

            self?.collectionView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }, onError: {
            [weak self] _ in
            
            self?.collectionView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            Toast.show("Tải dữ liệu thất bại vui lòng kiểm tra lại")
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
                    Toast.show("Tải hỉnh thành công")
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
        cell.isCheckMode = self.selectedBlock != nil
        cell.delegate = self
        
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
}

extension EVImagesViewController: EVImageStoreCellDelegate {
    
    func didLongPress(at item: EVImageResource) {
        
        let actionController = PeriscopeActionController()
        actionController.headerData = "Bạn có muốn xoá hình ảnh này ?"
        
        actionController.addAction(Action("Xoá", style: .destructive, handler: {
            action in
            MBProgressHUD.showHUDLoading()
            _ = EVImageServices.deleteSupplierImage(item.id)
                .subscribe(onNext: {
                    success in
                    MBProgressHUD.hideHUDLoading()
                    
                    let mess = success ? "Xoá thành công" : "Xoá thất bại"
                    Toast.show(mess)
                    
                    if !success {
                        return
                    }
                    
                    if let index = EVSupplier.current!.images.index(of: item) {
                        EVSupplier.current!.images.remove(at: index)
                        self.collectionView.reloadData()
                    }
                })
        }))
        
        actionController.addSection(PeriscopeSection())
        
        actionController.addAction(Action("Huỷ bỏ", style: .cancel, handler: {
            action in
            
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    func didPressed(at cell: EVImageStoreCell, item: EVImageResource) {
        
        self.animationImageView = cell.mainImageView
        let controller = CPImageViewerViewController()
        controller.transitioningDelegate = CPImageViewerAnimator()
        controller.image = animationImageView.image
        
        self.present(controller, animated: true, completion: nil)
    }
}
