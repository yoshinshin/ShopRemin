//
//  UserSettingViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/30.
//

import UIKit
import UserNotifications

class SettingListViewController: UITableViewController {
    static let showEditSegueIdentifier = "EditSegue"
    static let viewControllerIdetifier = "UserSettingViewController"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showEditSegueIdentifier, let destination = segue.destination as? SettingEditViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let section = indexPath.section
            let row = indexPath.row
            let rowType = SettingListDataSource.SettingRow.allCases[row]
            guard let setting = dataSource?.setting(section: section) else {fatalError("settingがありません")}
            destination.configure(setting, rowType: rowType) { setting in
                self.dataSource?.update(setting, at: section)
                self.updateNotification(setting)
            }
        }
    }
    
    private var dataSource: SettingListDataSource! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = SettingListDataSource() { indexPath, isOn in
            UserSetting.userData[indexPath.section].isOn = isOn
            let setting = UserSetting.userData[indexPath.section]
            self.configureNotifications(setting: setting, isOn: isOn)
        }
        tableView.dataSource = dataSource
        navigationItem.title = "買い物に行く日を設定"
    }
    
    func configureNotifications(setting: UserSetting, isOn: Bool) {
        if isOn {
            addNotification(setting)
        } else {
            removeNotification(setting)
        }
    }
    
    func updateNotification(_ setting: UserSetting) {
        guard setting.isOn else {return}
        let request = UNNotificationRequest(identifier: setting.id, content: content(), trigger: trigger(setting))
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {print("エラーです。詳細：\(String(describing: error))")}
        }
    }
    
    func addNotification(_ setting: UserSetting) {
        let request = UNNotificationRequest(identifier: setting.id, content: content(), trigger: trigger(setting))
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {print("エラーです。詳細：\(String(describing: error))")}
        }
    }
    
    func dateComponents(_ setting: UserSetting) -> DateComponents {
        guard let shoppingTime = setting.shoppingTime.toDate(UserSetting.timeFormat) else { fatalError("shoppoingTimeの変換に失敗") }
        var dateComponent = Calendar.current.dateComponents([.hour ,.minute], from: shoppingTime)
        dateComponent.weekday = setting.shoppigDay.rawValue
        dateComponent.hour = dateComponent.hour! - 1 > 0 ? dateComponent.hour! - 1 : 0
        return dateComponent
    }
    
    func content() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "買い物の時間です"
        content.body = "リストを作成して、買い物に行きましょう"
        content.sound = UNNotificationSound.default
        return content
    }
    
    func trigger(_ setting: UserSetting) -> UNCalendarNotificationTrigger {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents(setting), repeats: true)
        return trigger
    }
    
    func removeNotification(_ setting: UserSetting) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [setting.id])
    }
}
