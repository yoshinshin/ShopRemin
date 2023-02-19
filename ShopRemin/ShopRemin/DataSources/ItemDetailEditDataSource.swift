//
//  ItemDetailEditDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/03.
//

import UIKit

class ItemDetailEditDataSource: NSObject {
    typealias ItemChangeAction = (RegularItem) -> Void
    enum ItemEditRow {
        case boughtDate
        case consumptionDays
        
        var identifier: String {
            switch self {
            case .boughtDate:
                return "DatePickerCell"
            case .consumptionDays:
                return "EditConsumptionDaysCell"
            }
        }
    }
    
    private var item: RegularItem
    private var rowType: ItemDetailViewDataSource.ItemDetailRow
    private var itemChangeAction: ItemChangeAction
    private var cellType: ItemEditRow? {
        switch rowType {
        case .boughtDate:
            return .boughtDate
        case .consumptionDays:
            return .consumptionDays
        default:
            return nil
        }
    }

    init(item: RegularItem, rowType: ItemDetailViewDataSource.ItemDetailRow, changeAction: @escaping ItemChangeAction) {
        self.item = item
        self.rowType = rowType
        self.itemChangeAction = changeAction
        super.init()
    }
}

extension ItemDetailEditDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = cellType else {fatalError("編集画面のセルの生成に失敗")}
        let identifier = row.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        switch row {
        case .boughtDate:
            if let boughtDateCell = cell as? DatePickerCell {
                boughtDateCell.configure(date: item.boughtDate, maximumDate: Date()) { date in
                    self.item.boughtDate = date
                    self.itemChangeAction(self.item)
                }
            }
        case .consumptionDays:
            if let consumptionDaysCell = cell as? EditConsumptionDaysCell {
                consumptionDaysCell.configure(currentValue: item.consumptionDays) { days in
                    self.item.consumptionDays = days
                    self.itemChangeAction(self.item)
                }
            }
        }
        return cell
    }
}
