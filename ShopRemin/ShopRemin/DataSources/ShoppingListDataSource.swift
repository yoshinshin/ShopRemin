//
//  ShoppingListViewDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/16.
//

import UIKit

class ShoppingListDataSource: NSObject {
    enum Section: Int, CaseIterable {
        case onceItems
        case regulaItems
        
        var numRows: Int {
            switch self {
            case .onceItems:
                return ShoppingList.userData?.onceItems?.count ?? 0
            case .regulaItems:
                return ShoppingList.userData?.regularItems?.count ?? 0
            }
        }
    }
    
    private var shoppingList: ShoppingList? { ShoppingList.userData }
    
    func update(_ item: Item, section: Int, row: Int) {
        if section == 0 {
            ShoppingList.userData!.onceItems![row] = item as! OnceItem
        } else {
            ShoppingList.userData!.regularItems![row] = item as! RegularItem
        }
    }
    
    func item(section: Int, row: Int) -> Item {
        if section == 0 {
            return ShoppingList.userData!.onceItems![row]
        } else {
            return ShoppingList.userData!.regularItems![row]
        }
    }
    
    func index(_ onceItem: OnceItem) -> Int? {
        return ShoppingList.userData?.onceItems?.firstIndex(where: { $0.id == onceItem.id })
    }
    
    func delete(at indexPath: IndexPath) {
        let row = indexPath.row
        if indexPath.section == 0 {
            ShoppingList.userData?.onceItems?.remove(at: row)
            ShoppingList.userData?.regularItems?.remove(at: row)
        }
    }
    
    func dequeueAndReusableCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.shoppingListCellIdentifier, for: indexPath) as? ShoppingListCell else { fatalError("セルの生成に失敗") }
        var currentItem: Item
        switch section {
        case .onceItems:
            currentItem = ShoppingList.userData!.onceItems![indexPath.row]
        case .regulaItems:
            currentItem = ShoppingList.userData!.regularItems![indexPath.row]
        }
        cell.configure(title: currentItem.name, shouldBuy: currentItem.shouldBuy) {
            currentItem.shouldBuy.toggle()
            self.update(currentItem,section: indexPath.section, row: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}

extension ShoppingListDataSource: UITableViewDataSource {
    static let shoppingListCellIdentifier = "ShoppingListCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section.allCases[section]
        return section.numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueAndReusableCell(for: indexPath, from: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shoppingList?.regularItems != nil && section == 1 ? "定期購入品" : nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        delete(at: indexPath)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }) { (_) in
            tableView.reloadData()
        }
    }
}
