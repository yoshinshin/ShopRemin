//
//  RightDetailCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/06.
//

import UIKit

class RightDetailCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    func configure(title: String, detail: String, image: UIImage?) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
        self.imageView?.image = image
        self.selectionStyle = .none
    }

}
