//
//  EditBasicCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class EditBasicCell: UITableViewCell {
    typealias ChangeAction = (UITableViewCell) -> Void
    @IBOutlet var titleLabel: UILabel!
    private var changeAction: ChangeAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            accessoryType = .checkmark
            self.changeAction?(self)
        } else {
            accessoryType = .none
        }
    }
    
    func configure(title: String,changeAction: @escaping ChangeAction) {
        titleLabel.text = title
        selectionStyle = .none
        self.changeAction = changeAction
    }

}
