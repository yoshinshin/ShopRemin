//
//  ShoppingItemDetailViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/10/30.
//

import UIKit

class ItemDetailViewController: UITableViewController, UINavigationControllerDelegate {
    typealias ItemChangedAction = (RegularItem) -> Void
    private var item: RegularItem! = nil
    private var isNew = false
    private var editAction: ItemChangedAction?
    private var addAction: ItemChangedAction?
    private var dataSource: ItemDetailViewDataSource?
    private static let editViewControllerIdentifier = "ItemDetailEditViewController"
    
    override func viewDidLoad() {
        dataSource = ItemDetailViewDataSource(item: item, isNew: isNew, changeAction: { item in
            self.item = item
            if self.isNew { self.configureRightBarButtonItem() }
        }, selectedAction: { cellType in
            self.showEditViewController(cellType)
        })
        if isNew {
            configureNavigationBar()
        } else {
            navigationController?.delegate = self
        }
        tableView.dataSource = dataSource
        super.viewDidLoad()
    }
    
    
    func configure(with item: RegularItem, isNew: Bool = false, editAction: ItemChangedAction? = nil, addAction: ItemChangedAction? = nil) {
        self.item = item
        self.isNew = isNew
        self.editAction = editAction
        self.addAction = addAction
    }
    
    func configureRightBarButtonItem() {
        if item!.name.isEmpty || item!.consumptionDays == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ItemListContainerViewController {
            editAction?(item)
        }
    }
    
    func showEditViewController(_ cellType: ItemDetailViewDataSource.ItemDetailRow) {
        let storyboard = mainStoryboard()
        let editViewController: ItemDetailEditViewController = storyboard.instantiateViewController(identifier: Self.editViewControllerIdentifier)
        editViewController.configure(with: item!, rowType: cellType) { item in
            self.item = item
            self.viewDidLoad() //疑いの余地あり
        }
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func configureNavigationBar() {
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelButtonTriggered)), animated: false)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(doneButtonTriggered)), animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    func cancelButtonTriggered() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func doneButtonTriggered() {
        dismiss(animated: true) {
            self.addAction?(self.item)
        }
    }
}
