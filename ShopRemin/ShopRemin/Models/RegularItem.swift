//
//  Item.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/31.
//

import Foundation
import CoreText

struct RegularItem: Item {
    var id: String
    var name: String
    var notes: String = ""
    var consumptionDays: Int
    var boughtDate: Date? = nil
    var shouldBuy: Bool = true
}

extension RegularItem {
    static var userData: [RegularItem] = [
    
    ]
    
    static func regularItems (shoppingDate: Date) -> [RegularItem] {
        var shouldBuyItems = userData.filter({ $0.shouldBuy })
        let shouldNotBuyItems = userData.filter( { !($0.shouldBuy) } )
        shouldBuyItems.append(contentsOf: computedShouldBuyItems(shoudNotBuyItems: shouldNotBuyItems ,shoppingDate: shoppingDate))
        shouldBuyItems.indices.forEach { shouldBuyItems[$0].shouldBuy = true }
        return shouldBuyItems
    }
    
    static func computedShouldBuyItems( shoudNotBuyItems items: [RegularItem], shoppingDate date: Date) -> [RegularItem] {
        let computedShouldBuyItems = items.filter({
            guard let boughtDate = $0.boughtDate else { return false }
            guard let nextBuyDate = Calendar.current.date(byAdding: .day, value: $0.consumptionDays, to: boughtDate) else { return false }
            return date >= nextBuyDate
        })
        return computedShouldBuyItems
    }
}
