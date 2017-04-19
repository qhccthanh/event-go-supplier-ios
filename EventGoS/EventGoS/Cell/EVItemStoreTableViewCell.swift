//
//  EVItemStoreTableViewCell.swift
//  EventGoS
//
//  Created by Nguyen Xuan Thai on 4/17/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit

class EVItemStoreTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarStoreImageView: UIImageView!
    @IBOutlet weak var nameStoreLabel: UILabel!
    @IBOutlet weak var latStoreLabel: UILabel!
    @IBOutlet weak var longStoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
