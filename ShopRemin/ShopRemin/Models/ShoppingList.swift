//
//  ShoppingList.swift.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/14.
//

import UIKit

struct ShoppingList {
    var title: String = ""
    var shoppingDate: Date = Date()
    var onceItems: [OnceItem]? = nil
    var regularItems: [RegularItem]? = nil
}

extension ShoppingList {
    static var userData: ShoppingList?
}
