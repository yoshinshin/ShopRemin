//
//  EditTimePickerCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class EditTimePickerCell: UITableViewCell {
    typealias TimeChangeAction = (String) -> Void
    private var timeChangeAction: TimeChangeAction?
    @IBOutlet var timePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
    }
    
    func configure(time: String, changeAction: @escaping TimeChangeAction) {
        self.timeChangeAction = changeAction
        guard let currentTime = time.toDate("HH時mm分") else {fatalError("date型への変換に失敗")}
        timePicker.locale = Locale(identifier: "ja_JP")
        timePicker.date = currentTime
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let selectedTime = sender.date.toFormat("HH時mm分")
        timeChangeAction?(selectedTime)
    }

}
