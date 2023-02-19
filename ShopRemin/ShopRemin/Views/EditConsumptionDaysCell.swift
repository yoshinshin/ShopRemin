//
//  EditConsumptionDaysCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/04.
//

import UIKit

class EditConsumptionDaysCell: UITableViewCell {
    typealias PickerChangeAction = (Int) -> Void
    @IBOutlet var cunsumptionDaysPickerView: UIPickerView!
    private var pickerChangeAction: PickerChangeAction?
    private var currentValue: Int?
    private var allValues: [Int] = Array(0...30)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cunsumptionDaysPickerView.dataSource = self
        self.cunsumptionDaysPickerView.delegate = self
    }
    
    func configure(currentValue: Int?, changeAction: @escaping PickerChangeAction) {
        self.currentValue = currentValue ?? 0
        self.pickerChangeAction = changeAction
        self.cunsumptionDaysPickerView.selectRow(allValues.firstIndex(of: currentValue ?? 0) ?? 0, inComponent: 0, animated: false)
    }
}

extension EditConsumptionDaysCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allValues[row] == 0 ? "---" : "\(allValues[row])日間"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerChangeAction?(allValues[row])
    }
}
