//
//  ShoppingListCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/16.
//

import UIKit

class ShoppingListCell: UITableViewCell {
    typealias BoughtButtonAction = () -> Void
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var boughtButton: UIButton!
    private var boughtButtonAction: BoughtButtonAction?
    
    func configure(title: String, shouldBuy: Bool, boughtButtonAction: @escaping BoughtButtonAction) {
        titleLabel.text = title
        self.boughtButtonAction = boughtButtonAction
        let image = shouldBuy ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "checkmark.square.fill")
        boughtButton.setImage(image, for: .normal)
        
    }
    
    @IBAction func boughtButtonTriggered(_ sender: UIButton) {
        boughtButtonAction?()
    }
    
    
}
