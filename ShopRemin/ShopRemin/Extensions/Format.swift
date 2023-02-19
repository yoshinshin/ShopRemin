//
//  Format.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2022/02/25.
//

import Foundation

extension Date {
    func toFormat(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
