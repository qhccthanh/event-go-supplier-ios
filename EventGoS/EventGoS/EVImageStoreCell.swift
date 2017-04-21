//
//  EVImageStoreCell.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/21/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import RxSwift

class EVImageStoreCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var createLabel: UILabel!
    
    var isCheckMode = false
    weak var imageStore: EVImageResource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isCheckMode {
            checkImageView.isHidden = !isCheckMode
        }
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
    
    @IBAction func onTouchChecked(_ sender: AnyObject!) {
        
        guard let imageStore = imageStore else {
            return
        }
        mainImageView.cancelImageRequestOperation()
        imageStore.isChecked = !imageStore.isChecked
        checkImageView.image = imageStore.isChecked ? #imageLiteral(resourceName: "ic_checked") : #imageLiteral(resourceName: "ic_dontCheck")
    }
}
