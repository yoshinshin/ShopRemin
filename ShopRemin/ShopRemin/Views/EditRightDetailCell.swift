//
//  RightDetailCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/06.
//

import UIKit

class EditRightDetailCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    private var selectedAction: (() -> Void)?
    
    func configure(title: String, detail: String, image: UIImage?, selectedAction: (() -> Void)? = nil) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
        self.imageView?.image = image
        self.selectedAction = selectedAction
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.selectedAction?()
        }
    }

}
