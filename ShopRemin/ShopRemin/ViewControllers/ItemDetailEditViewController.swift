//
//  ItemDetailEditViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/06.
//

import UIKit

class ItemDetailEditViewController: UITableViewController, UINavigationControllerDelegate {
    typealias ItemChangeAction = (RegularItem) -> Void
    private var item: RegularItem! = nil
    private var rowType: ItemDetailViewDataSource.ItemDetailRow! = nil
    private var itemChangeAction: ItemChangeAction?
    private var dataSource: ItemDetailEditDataSource! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ItemDetailEditDataSource(item: item,rowType: rowType) { item in
            self.item = item
            self.navigationController?.navigationBar.isUserInteractionEnabled = item.consumptionDays != 0
            self.navigationController?.navigationBar.tintColor = item.consumptionDays == 0 ? UIColor.lightGray : nil
        }
        tableView.dataSource = dataSource
        navigationItem.title = navigationTitle(self.rowType)
        navigationController?.delegate = self
    }
    
    func navigationTitle(_ rowType: ItemDetailViewDataSource.ItemDetailRow) -> String {
        switch rowType {
        case .boughtDate:
            return "前回購入日"
        case .consumptionDays:
            return "消費日数"
        default:
            return ""
        }
    }
    
    func configure(with item: RegularItem, rowType: ItemDetailViewDataSource.ItemDetailRow, changeAction: @escaping ItemChangeAction) {
        self.item = item
        self.rowType = rowType
        self.itemChangeAction = changeAction
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ItemDetailViewController {
            itemChangeAction?(self.item)
        }
    }
}
