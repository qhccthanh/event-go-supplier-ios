//
//  EVImageStoreCell.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import RxSwift

protocol EVImageStoreCellDelegate: class {
    func didLongPress(at item: EVImageResource)
    func didPressed(at cell: EVImageStoreCell, item: EVImageResource)
}

class EVImageStoreCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var createLabel: UILabel!
    
    var isCheckMode = false
    
    weak var imageStore: EVImageResource?
    weak var delegate: EVImageStoreCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isCheckMode {
            checkImageView.isHidden = !isCheckMode
        }
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longTapGesture.allowableMovement = 15
        longTapGesture.minimumPressDuration = 0.6
        self.addGestureRecognizer(longTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressed))
        self.addGestureRecognizer(tapGesture)
        
        let tapImageGesture  = UITapGestureRecognizer(target: self, action: #selector(onTouchChecked))
        self.checkImageView.addGestureRecognizer(tapImageGesture)
        self.checkImageView.isUserInteractionEnabled = true
    }
    
    func onPressed() {
        guard let imageStore = self.imageStore else {
            return
        }
        
        delegate?.didPressed(at: self,item: imageStore)
    }
    
    func longPress() {
        guard let imageStore = self.imageStore else {
            return
        }
        
        delegate?.didLongPress(at: imageStore)
    }
    
    func bindingUI(_ imageStore: EVImageResource) {
        
        self.imageStore = imageStore
        checkImageView.isHidden = !isCheckMode

        if let imageURL = URL(string: imageStore.url) {
            mainImageView.setImageWithUrl(imageURL, placeHolderImage: #imageLiteral(resourceName: "EventGo-Logo"))
        }
        
        createLabel.text = imageStore.create.toString()
        checkImageView.image = imageStore.isChecked ? #imageLiteral(resourceName: "ic_checked") : #imageLiteral(resourceName: "ic_dontCheck")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = #imageLiteral(resourceName: "EventGo-Logo")
        checkImageView.isHidden = true
        createLabel.text = ""
    }
    
    func onTouchChecked(_ sender: AnyObject!) {
        
        guard let imageStore = imageStore else {
            return
        }
        
        mainImageView.cancelImageRequestOperation()
        imageStore.isChecked = !imageStore.isChecked
        checkImageView.image = imageStore.isChecked ? #imageLiteral(resourceName: "ic_checked") : #imageLiteral(resourceName: "ic_dontCheck")
    }
}
