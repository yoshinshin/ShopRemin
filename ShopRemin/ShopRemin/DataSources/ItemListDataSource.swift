//
//  ShoppingListDataSource.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/31.
//

import UIKit

class ItemListDataSource: NSObject {
    var regularItems: [RegularItem] {
        return RegularItem.userData
    }
        
    func update(_ item: RegularItem, at row: Int) {
        RegularItem.userData[row] = item
    }
    
    func add(_ item: RegularItem) {
        RegularItem.userData.insert(item, at: 0)
    }
    
    func delete(at row: Int) {
        RegularItem.userData.remove(at: row)
    }

    func item(at row: Int) -> RegularItem {
        return regularItems[row]
    }
}

extension ItemListDataSource: UITableViewDataSource {
    static let listCellIdentifier = "ItemListCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regularItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.listCellIdentifier, for: indexPath) as? ItemListCell else { fatalError("ListViewCellが使えません") }
        let currentItem = item(at: indexPath.row)
        cell.configure(title: currentItem.name)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        delete(at: indexPath.row)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }) { (_) in
            tableView.reloadData()
        }
    }
}
