//
//  UserSettingEditViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class SettingEditViewController: UITableViewController, UINavigationControllerDelegate {
    typealias SettingChangeAction = (UserSetting) -> Void
    private var changeAction: SettingChangeAction?
    private var setting: UserSetting! = nil
    private var rowType: SettingListDataSource.SettingRow! = nil
    private var dataSource: SettingEditDataSource! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = SettingEditDataSource(setting, rowType: rowType){ setting in self.setting = setting }
        tableView.dataSource = dataSource
        navigationController?.delegate = self
        navigationItem.title = navigationTitle(self.rowType)
    }
    
    func navigationTitle(_ rowType: SettingListDataSource.SettingRow) -> String {
        switch rowType {
        case .day:
            return "曜日を編集"
        case .time:
            return "時間を編集"
        default:
            return ""
        }
    }
    
    func configure(_ setting: UserSetting, rowType: SettingListDataSource.SettingRow, changeAction: @escaping SettingChangeAction) {
        self.setting = setting
        self.rowType = rowType
        self.changeAction = changeAction
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if  viewController is SettingListViewController {
            self.changeAction?(setting!)
            viewController.viewDidLoad()
        }
    }
}
