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
    var isCheckMode = false
    weak var imageStore: ImageStore?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isCheckMode {
            checkImageView.isHidden = !isCheckMode
        }
    }
    
    func bindingUI(_ imageStore: ImageStore) {
        
        self.imageStore = imageStore
        checkImageView.isHidden = !isCheckMode
        
    }
}
