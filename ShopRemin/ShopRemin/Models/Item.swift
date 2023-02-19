//
//  Item.swift.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/14.
//

import Foundation

protocol Item {
    var id: String { get }
    var name: String { get set }
    var shouldBuy: Bool { get set }
}
