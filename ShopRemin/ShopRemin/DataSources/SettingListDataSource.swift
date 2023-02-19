//
//  UserSettingViewDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class SettingListDataSource: NSObject {    
    enum SettingRow: Int, CaseIterable {
        case noticeSwitch
        case day
        case time
        
        var cellImage: UIImage? {
            switch self {
            case .noticeSwitch:
                return nil
            case .day:
                return UIImage(systemName: "calendar")
            case .time:
                return UIImage(systemName: "clock")
            }
        }
        
        var cellIdentifier: String {
            switch self {
            case .noticeSwitch:
                return "SwitchCell"
            case .day, .time:
                return "EditRightDetailCell"
            }
        }
        
        func titleText(for setting: UserSetting) -> String {
            switch self {
            case .noticeSwitch:
                return "通知"
            case .day:
                return "曜日"
            case .time:
                return "時間"
            }
        }
        
        func detailText(for setting: UserSetting) -> String? {
            switch self {
            case .noticeSwitch:
                return nil
            case .day:
                return setting.shoppigDay.string
            case .time:
                return setting.shoppingTime
            }
        }
        
        
        
    }
    
    init(switchChangedAction: @escaping (IndexPath, Bool) -> Void) {
        self.switchChangedAction = switchChangedAction
        super.init()
    }
    
    private var switchChangedAction: (IndexPath, Bool) -> Void
    var settings: [UserSetting] {
        UserSetting.userData
    }
    
    func update(_ setting: UserSetting, at index: Int) {
        UserSetting.userData[index] = setting
    }
    
    func add(_ setting: UserSetting) {
        UserSetting.userData.insert(setting, at: 0)
    }
    
    func setting(section: Int) -> UserSetting {
        UserSetting.userData[section]
    }
    
}

extension SettingListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserSetting.settingNum
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = SettingRow.allCases[indexPath.row]
        let setting = settings[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)
        switch row {
        case .noticeSwitch:
            if let switchCell = cell as? SwitchCell {
                switchCell.configure(title: row.titleText(for: setting), isOn: setting.isOn) { isOn in
                    self.switchChangedAction(indexPath ,isOn)
                }
            }
        case .day, .time:
            if let editRightDetailCell = cell as? EditRightDetailCell {
                editRightDetailCell.configure(title: row.titleText(for: setting), detail: row.detailText(for: setting)!, image: row.cellImage)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "設定\(section + 1)"
    }
}
