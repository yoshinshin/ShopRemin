//
//  ShoppingListViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/30.
//

import UIKit

class ItemListViewController: UITableViewController {
    static let showDetailSegueIdentifier = "ShowDetailSegue"
    static let detailViewControllerIdentifier = "ItemDetailViewController"
    private var dataSource: ItemListDataSource! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ItemListDataSource()
        tableView.dataSource = dataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showDetailSegueIdentifier, let destination = segue.destination as? ItemDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let row = indexPath.row
            guard let item = dataSource?.item(at: row) else { fatalError("アイテムがありません") }
            destination.configure(with: item, editAction: { item in
                self.dataSource?.update(item, at: row)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
    }
    
    func createAddItemView() {
        let storyboard = mainStoryboard()
        let detailViewController: ItemDetailViewController = storyboard.instantiateViewController(identifier: Self.detailViewControllerIdentifier)
        let newItem = RegularItem(id: UUID().uuidString, name: "", consumptionDays: 0)
        detailViewController.configure(with: newItem, isNew: true, addAction: { item in
            self.dataSource?.add(item)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
        let navigationController = UINavigationController(rootViewController: detailViewController)
        navigationController.navigationItem.title = "新しい商品を追加"
        navigationController.showMidium()
        present(navigationController, animated: true, completion: nil)
    }
}
