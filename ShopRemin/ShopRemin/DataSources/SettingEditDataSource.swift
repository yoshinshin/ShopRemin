//
//  SettingEditDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class SettingEditDataSource: NSObject {
    typealias SettingChangeAction = (UserSetting) -> Void
    enum CellType: Int, CaseIterable {
        case day
        case time
        
        var cellIdentifier: String {
            switch self {
            case .day:
                return "EditBasicCell"
            case .time:
                return "EditTimePickerCell"
            }
        }
        
        var numRows: Int {
            switch self {
            case .day:
                return UserSetting.Days.allCases.count
            case .time:
                return 1
            }
        }
        
        func displayText(_ row: Int) -> String? {
            switch self {
            case .day:
                return UserSetting.Days.allCases[row].string
            case .time:
                return nil
            }
        }
    }
    
    private var chnageAction: SettingChangeAction
    private var setting: UserSetting
    private var rowType: SettingListDataSource.SettingRow
    private lazy var cellType = self.cellType(self.rowType)
    
    init(_ setting: UserSetting, rowType: SettingListDataSource.SettingRow, changeAction: @escaping SettingChangeAction) {
        self.setting = setting
        self.rowType = rowType
        self.chnageAction = changeAction
    }
    
    func cellType(_ rowType: SettingListDataSource.SettingRow) -> CellType? {
        switch rowType {
        case .day:
            return CellType.day
        case .time:
            return CellType.time
        default:
            return nil
        }
    }
}

extension SettingEditDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType?.numRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = cellType else { fatalError("表示可能なセルではありません") }
        let identifier = cellType.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        switch cellType {
        case .day:
            if let basicCell = cell as? EditBasicCell {
                tableView.selectRow(at: IndexPath(row: setting.shoppigDay.rawValue - 1, section: 0), animated: false, scrollPosition: .none)
                basicCell.configure(title: cellType.displayText(indexPath.row) ?? "") { cell in
                    if let row = tableView.indexPath(for: cell)?.row {
                        let day = UserSetting.Days.allCases[row]
                        self.setting.shoppigDay = day
                        self.chnageAction(self.setting)
                    }
                }
            }
        case .time:
            if let timePickerCell = cell as? EditTimePickerCell {
                timePickerCell.configure(time: setting.shoppingTime) { time in
                    self.setting.shoppingTime = time
                    self.chnageAction(self.setting)
                }
            }
        }
        return cell
    }
}
