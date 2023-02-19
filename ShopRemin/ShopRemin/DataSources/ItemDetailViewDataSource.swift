//
//  ItemDetailViewDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/03.
//

import UIKit

class ItemDetailViewDataSource: NSObject {
    typealias ItemChangeAction = (RegularItem) -> Void
    typealias SelectedAction = (ItemDetailRow) -> Void
    
    enum ItemDetailRow: Int, CaseIterable {
        case title, shouldBuy, remainingDays, consumptionDays, boughtDate, notes
        
        var cellImage: UIImage? {
            switch self {
            case .title, .shouldBuy, .notes:
                return nil
            case .remainingDays:
                return UIImage(systemName: "clock")
            case .consumptionDays:
                return UIImage(systemName: "calendar.badge.clock")
            case .boughtDate:
                return UIImage(systemName: "bag")
            }
        }
        
        var identifier: String {
            switch self {
            case .title:
                return "EditTitleCell"
            case .shouldBuy:
                return "SegmentedControlCell"
            case .remainingDays:
                return "RightDetailCell"
            case .consumptionDays, .boughtDate:
                return "EditRightDetailCell"
            case .notes:
                return "EditNotesCell"
            }
        }
        
        func dispayText(for item: RegularItem) -> String {
            switch self {
            case .title:
                return item.name
            case .shouldBuy:
                return "在庫の有無"
            case .remainingDays:
                guard let boughtDate = item.boughtDate else { return "あと0日" }
                let remainingDays = remainingDays(boughtDate: boughtDate, consumptionDays: item.consumptionDays)
                return remainingDays > 0 ? "あと\(remainingDays)日" : "購入する必要があります"
            case .consumptionDays:
                guard item.consumptionDays != 0 else { return "消費日数を設定してください" }
                return "\(item.consumptionDays)日"
            case .boughtDate:
                guard let boughtDate = item.boughtDate else { return "前回購入日を設定してください" }
                return boughtDate.toFormat("M月d日(EEEEE)")
            case .notes:
                return item.notes
            }
        }
        
        func remainingDays(boughtDate: Date, consumptionDays: Int) -> Int {
            let calender = Calendar.current
            let nextBuyDate = calender.startOfDay(for: Calendar.current.date(byAdding: .day, value: consumptionDays, to: boughtDate)!)
            let today = calender.startOfDay(for: Date())
            let remainingDays = calender.dateComponents([.day], from: today, to: nextBuyDate).day!
            return remainingDays
        }
    }
    
    private var item: RegularItem
    private var isNew: Bool
    private var cellType: [ItemDetailRow] {
        return isNew ? [.title,.consumptionDays,.boughtDate] : ItemDetailRow.allCases
    }
    private var itemChangeAction: ItemChangeAction?
    private var selectedAction: SelectedAction?
    
    init(item: RegularItem, isNew:Bool, changeAction: @escaping ItemChangeAction, selectedAction: @escaping SelectedAction) {
        self.item = item
        self.isNew = isNew
        self.itemChangeAction = changeAction
        self.selectedAction = selectedAction
        super.init()
    }
    
    func update(_ item: RegularItem, at row: Int) {
        RegularItem.userData[row] = item
    }
    
    func dequeueAndReusableCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        let row = cellType[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath)
        switch row {
        case .title:
            if let titleCell = cell as? EditTitleCell {
                titleCell.configure(title: row.dispayText(for: item),placeholder: "商品名を設定してください"){ title in
                    self.item.name = title
                    self.itemChangeAction?(self.item)
                }
            }
        case .shouldBuy:
            if let segmentedCell = cell as? SegmentedControlCell {
                let segmentedValues = ["在庫あり", "在庫なし"]
                segmentedCell.configure(title: row.dispayText(for: item), values: segmentedValues, selectedIndex: item.shouldBuy ? 1 : 0) { index in
                    self.item.shouldBuy = index == 1
                    self.itemChangeAction?(self.item)
                }
            }
        case .remainingDays:
            if let remainingDaysCell = cell as? RightDetailCell {
                remainingDaysCell.configure(title: "残り日数", detail: row.dispayText(for: item), image: row.cellImage)
            }
        case .consumptionDays:
            if let consumptionDaysCell = cell as? EditRightDetailCell {
                consumptionDaysCell.configure(title: "消費日数", detail: row.dispayText(for: item), image: row.cellImage) {
                    self.selectedAction?(.consumptionDays)
                }
            }
        case .boughtDate:
            if let boughtDateCell = cell as? EditRightDetailCell {
                boughtDateCell.configure(title: "前回購入日", detail: row.dispayText(for: item), image:  row.cellImage) {
                    self.selectedAction?(.boughtDate)
                }
            }
        case .notes:
            if let notesCell = cell as? EditNotesCell {
                notesCell.configure(text: row.dispayText(for: item)){ notes in
                    self.item.notes = notes
                    self.itemChangeAction?(self.item)
                }
            }
        }
        return cell
    }
}

extension ItemDetailViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndReusableCell(for: indexPath, from: tableView)
    }
}
