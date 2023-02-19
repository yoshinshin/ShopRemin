//
//  SwitchCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class SwitchCell: UITableViewCell {
    typealias SwitchChangeAction = (Bool) -> Void
    @IBOutlet var switchButton: UISwitch!
    @IBOutlet var titleLabel: UILabel!
    private var switchChangeAction: SwitchChangeAction?
    
    func configure(title: String,isOn: Bool ,changeAction: @escaping SwitchChangeAction) {
        self.titleLabel.text = title
        self.switchButton.isOn = isOn
        self.switchChangeAction = changeAction
        self.selectionStyle = .none
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        self.switchChangeAction?(sender.isOn)
    }
}
