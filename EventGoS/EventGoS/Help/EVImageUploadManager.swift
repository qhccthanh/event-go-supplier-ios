//
//  EVImageUploadManager.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import DKImagePickerController
import RxSwift

typealias UploadImageBlock = (_ index: Int) -> Void

extension UIImage {
    
    func scaleImage(_ maxSize: CGFloat = 1024) -> UIImage {
        
        let size = self.size
        if size.width < maxSize && size.height < maxSize {
            return self
        }
        
        let scaleWithWidth = size.height > size.width
        let newSizeOther = scaleWithWidth ? size.width * (maxSize/size.height) : size.height * (maxSize/size.width)
        let newSize = CGSize(width: scaleWithWidth ? maxSize : newSizeOther,
                             height: scaleWithWidth ? newSizeOther : maxSize)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class EVImageUploadManager: NSObject {
    
//    static var manager: EVImageUploadManager = EVImageUploadManager()
//    var imageController: EVImagesViewController!
//    var imageUploading: [DKAsset] = []
//    var successBlock: ((_ stores: [EVImageResource]) -> Void)?
//    var progressBlock: ((_ index: Int) -> Void)?
//    var storeCache: [EVImageResource] = []
    
    private override init() {
        super.init()
    }
    
//    func uploadImage(_ images: [DKAsset], progressBlock: @escaping (_ index: Int) -> Void, successBlock: @escaping (_ stores: [EVImageResource]) -> Void) {
//        storeCache.removeAll()
//        
//        self.imageUploading = images
//        self.successBlock = successBlock
//        self.progressBlock = progressBlock
//        
//        self.uploadImage(at: 0)
//    }
    
    class func uploadImage(_ assets: [DKAsset]) -> Observable<EVImageResource> {
        
        let fetchImage = Observable<UIImage>.create { (sub) -> Disposable in
            assets.forEach({ (asset) in
            
                asset.fetchOriginalImage(false, completeBlock: {
                    ( image, into) in
                    guard let image = image else {
                        sub.onError(NSError())
                        sub.onCompleted()
                        return
                    }
                    
                    sub.onNext(image.scaleImage())
                })
            })
            
            return Disposables.create()
        }
        
        return fetchImage.flatMap { (image) -> Observable<(EVImageResource)> in
            let imageStore = EVImageResource(name: "", image: image)
            return EVImageServices.uploadImage(imageStore: imageStore)
        }.observeOn(MainScheduler.instance)
    }
    
//    func uploadImage(at index: Int) {
//        
//        if index > self.imageUploading.count - 1 {
//            self.successBlock?(self.storeCache)
//            return
//        }
//        let imageData = self.imageUploading[index]
//        imageData.fetchOriginalImage(false, completeBlock: { ( image, into) in
//            guard let image = image else {
//                return
//            }
//            
//            let imageStore = EVImageResource(name: "image\(self.imageUploading.index(of: imageData)!)", image: image)
////            EVImageServices.uploadImage(imageStore: imageStore, callback: { (store) in
////                self.progressBlock?(index)
////                let indexNext = index + 1
////                
////                if let store = store {
////                    self.storeCache.append(store)
////                }
////                
////                self.uploadImage(at: indexNext)
////            })
//        })
//    }
    
}
