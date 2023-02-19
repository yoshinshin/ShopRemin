//
//  UserSetting.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import Foundation

struct UserSetting {
    var id: String
    var isOn: Bool
    var shoppigDay: Days
    var shoppingTime: String
    
    static let settingNum = 4
    static let timeFormat = "HH時mm分"
    
    enum Days: Int, CaseIterable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        var string: String {
            switch self {
            case .sunday: return "日曜日"
            case .monday: return "月曜日"
            case .tuesday: return "火曜日"
            case .wednesday: return "水曜日"
            case .thursday: return "木曜日"
            case .friday: return "金曜日"
            case .saturday: return "土曜日"
            }
        }
    }
}
    
extension UserSetting {
    static var userData = [
        UserSetting(id: UUID().uuidString, isOn: false ,shoppigDay: .sunday, shoppingTime: "00時00分"),
        UserSetting(id: UUID().uuidString, isOn: false ,shoppigDay: .sunday, shoppingTime: "00時00分"),
        UserSetting(id: UUID().uuidString, isOn: false,shoppigDay: .sunday, shoppingTime: "00時00分"),
        UserSetting(id: UUID().uuidString, isOn: false,shoppigDay: .sunday, shoppingTime: "00時00分")
    ]
}
