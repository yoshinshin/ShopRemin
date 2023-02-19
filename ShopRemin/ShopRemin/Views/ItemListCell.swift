//
//  ListViewCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/31.
//

import UIKit

class ItemListCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
        self.selectionStyle = .none
    }
}
