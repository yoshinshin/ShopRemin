//
//  ShoppingListTableViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/16.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {
    private var dataSource: ShoppingListDataSource! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    func configureDataSource() {
        dataSource = ShoppingListDataSource()
        tableView.dataSource = dataSource
    }
    
    func add(_ item: Item) {
        guard let addItem = item as? OnceItem else { fatalError("追加されるアイテムがOnceItemとしてキャストできません") }
        ShoppingList.userData?.onceItems == nil ? ShoppingList.userData?.onceItems = [addItem] : ShoppingList.userData!.onceItems!.append(addItem)
        if let index = self.dataSource.index(addItem) {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
         
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            var selectedItem = dataSource.item(section: indexPath.section, row: indexPath.row)
            guard let shoppingListViewController = self.parent as? ShoppingListViewController else { fatalError("親のviewcontrollerの取得に失敗") }
            shoppingListViewController.selectedCell(selectedItem) { text in
                selectedItem.name = text
                self.dataSource.update(selectedItem, section: indexPath.section, row: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
