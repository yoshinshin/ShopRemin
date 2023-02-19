//
//  CreateNewListViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/17.
//

import UIKit

class CreateNewListViewController: UITableViewController {
    typealias CreateListAction = () -> Void
    typealias DateChangeAction = (Date) -> Void
    
    var shoppingList: ShoppingList {
        ShoppingList.userData!
    }
    private var dataSource: CreateNewListDataSource! = nil
    private var createListAction: CreateListAction?
    private var dateChangeAction: DateChangeAction?
    private var shoppingDate: Date? = nil
    private var isList = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSource()
    }
    
    func configure(isList: Bool,createListAction: CreateListAction? = nil, dateChangeAction: DateChangeAction? = nil) {
        self.isList = isList
        self.createListAction = createListAction
        self.dateChangeAction = dateChangeAction
        self.shoppingDate = shoppingList.shoppingDate
    }
    
    func configureDataSource() {
        dataSource = CreateNewListDataSource(shoppingList, isList: isList) { shoppingList in
            ShoppingList.userData = shoppingList
        }
        tableView.dataSource = dataSource
    }
    
    func configureNavigationBar() {
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelButtonTriggered)), animated: false)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(doneButtonTriggered)), animated: false)
        navigationItem.title = isList ? "新規作成" : "日付を編集"
    }
    
    @objc func cancelButtonTriggered() {
        dismiss(animated: true) {
            if self.isList {
                ShoppingList.userData = nil
            }
        }
    }
    
    @objc func doneButtonTriggered() {
        if isList {
            ShoppingList.userData = self.shoppingList
            dismiss(animated: true) { self.createListAction?() }
        } else {
            dismiss(animated: true) { self.dateChangeAction?(self.shoppingList.shoppingDate) }
        }
    }
}
