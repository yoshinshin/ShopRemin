//
//  EditBoughtDateCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/04.
//

import UIKit

class DatePickerCell: UITableViewCell {
    typealias DateChangeAction = (Date) -> Void
    @IBOutlet var datePicker: UIDatePicker!
    
    private var dateChangeAction: DateChangeAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    func configure(date: Date?, maximumDate: Date? = nil, minimumDate: Date? = nil,changeAction: @escaping DateChangeAction) {
        datePicker.date = date ?? Date()
        self.dateChangeAction = changeAction
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.maximumDate = maximumDate
        datePicker.minimumDate = minimumDate
    }

    @objc
    func dateChanged(_ sender: UIDatePicker) {
        self.dateChangeAction?(sender.date)
    }
}
