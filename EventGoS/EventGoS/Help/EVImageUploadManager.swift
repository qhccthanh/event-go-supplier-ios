//
//  EVImageUploadManager.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/18/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import DKImagePickerController

typealias UploadImageBlock = (_ index: Int) -> Void

class EVImageUploadManager: NSObject {
    
    static var manager: EVImageUploadManager = EVImageUploadManager()
    var imageController: EVImagesViewController!
    var imageUploading: [DKAsset] = []
    var successBlock: ((_ stores: [ImageStore]) -> Void)?
    var progressBlock: ((_ index: Int) -> Void)?
    var storeCache: [ImageStore] = []
    
    private override init() {
        super.init()
    }
    
    func uploadImage(_ images: [DKAsset], progressBlock: @escaping (_ index: Int) -> Void, successBlock: @escaping (_ stores: [ImageStore]) -> Void) {
        storeCache.removeAll()
        
        self.imageUploading = images
        self.successBlock = successBlock
        self.progressBlock = progressBlock
        
        self.uploadImage(at: 0)
    }
    
    func uploadImage(at index: Int) {
        
        if index > self.imageUploading.count - 1 {
            self.successBlock?(self.storeCache)
            return
        }
        let imageData = self.imageUploading[index]
        imageData.fetchOriginalImage(false, completeBlock: { ( image, into) in
            guard let image = image else {
                return
            }
            
            let imageStore = ImageStore(name: "image\(self.imageUploading.index(of: imageData)!)", image: image)
            EVImageServices.uploadImage(imageStore: imageStore, callback: { (store) in
                self.progressBlock?(index)
                let indexNext = index + 1
                
                if let store = store {
                    self.storeCache.append(store)
                }
                
                self.uploadImage(at: indexNext)
            })
        })
    }
    
}
