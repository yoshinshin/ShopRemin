//
//  ShoppingListViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/16.
//

import UIKit

class ShoppingListViewController: UIViewController {
    @IBOutlet var buttomMenuView: UIStackView!
    @IBOutlet var listContainerView: UIView!
    static let createNewListViewControllerIdentifier = "CreateNewListViewController"
    private weak var doneAction: UIAlertAction?
    private var shoppingList: ShoppingList? {
        return ShoppingList.userData
    }
    private var shoppingListTableViewController: ShoppingListTableViewController {
        let childViewController = children[0] as! ShoppingListTableViewController
        return childViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationTitle()
    }
    
    func configureView() {
        configureNavigationTitle()
        buttomMenuView.isHidden = shoppingList == nil
        listContainerView.isHidden = shoppingList == nil
        navigationItem.setRightBarButton(shoppingList == nil ? createNewListButtonItem() : ellipsisBarButtonItem(), animated: false)
        shoppingListTableViewController.tableView.reloadData()
    }
    
    func configureNavigationTitle() {
        guard let shoppingList = shoppingList else {
            navigationItem.titleView = nil
            navigationItem.title = "買い物リスト"
            return
        }
        navigationItem.setTitleView(withTitle: shoppingList.title.isEmpty ? "タイトルなし" : shoppingList.title, subTitile: shoppingList.shoppingDate.toFormat("M月d日"))
    }
    
    func ellipsisBarButtonItem() -> UIBarButtonItem {
        let ellipsisBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        let actions = ellipsisBarButtonActions()
        let menu = UIMenu(title: "", children: actions)
        ellipsisBarButtonItem.menu = menu
        return ellipsisBarButtonItem
    }
    
    func ellipsisBarButtonActions() -> [UIAction] {
        let changeNameAction = UIAction(title: "リスト名を変更する", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { (_) in
            let alert = self.textFieldAlert(name: "リスト名を編集", initName: self.shoppingList?.title, placeholder: "リスト名") { text in
                ShoppingList.userData?.title = text
                self.configureNavigationTitle()
            }
            self.present(alert, animated: true, completion: nil)
        }
        let changeShoppingDateAction = UIAction(title: "日付を変更する", image: UIImage(systemName: "calendar")) { _ in self.changeShoppingDate()}
        let deleteAction = UIAction(title: "削除する", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in self.deleteList()}
        let actions = [changeNameAction, changeShoppingDateAction, deleteAction]
        return actions
    }
    
    func createNewListButtonItem() -> UIBarButtonItem {
        let createNewListButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showCreateNewListViewController))
        return createNewListButtonItem
    }
    
    @objc
    func showCreateNewListViewController() {
        let storyboard = mainStoryboard()
        let createNewListViewController: CreateNewListViewController = storyboard.instantiateViewController(identifier: Self.createNewListViewControllerIdentifier)
        configureShoppingList()
        createNewListViewController.configure(isList: true, createListAction: {
            self.configureView()
        })
        let navigationController = UINavigationController(rootViewController: createNewListViewController)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(navigationController, animated: true, completion: nil)
    }
    
    func changeShoppingDate() {
        let storyboard = mainStoryboard()
        guard let createNewListViewController = storyboard.instantiateViewController(withIdentifier: Self.createNewListViewControllerIdentifier) as? CreateNewListViewController else {fatalError("VeiwControllerの生成に失敗")}
        createNewListViewController.configure(isList: false, dateChangeAction: { date in
            ShoppingList.userData?.shoppingDate = date
            self.configureNavigationTitle()
        })
        let navigationController = UINavigationController(rootViewController: createNewListViewController)
        navigationController.showMidium()
        present(navigationController, animated: true)
    }
    
    func configureShoppingList() {
        ShoppingList.userData = ShoppingList(title: "", shoppingDate: Date())
        ShoppingList.userData!.regularItems = RegularItem.regularItems(shoppingDate: ShoppingList.userData!.shoppingDate)
    }
    
    @IBAction func exitShoppingButtonTriggered(_ sender: UIButton) {
        let alert = exitShoppingAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func exitShopping() {
        if let regularItems = shoppingList?.regularItems {
            RegularItem.userData.indices.forEach({
                for i in 0 ..< regularItems.count {
                    if RegularItem.userData[$0].id == regularItems[i].id { RegularItem.userData[$0].shouldBuy = regularItems[i].shouldBuy }
                }
            })
        }
        deleteList()
    }
    
    func exitShoppingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "買い物を終了しますか？", message: nil, preferredStyle: .actionSheet)
        let exitShoppingAction = UIAlertAction(title: "終了する", style: .default,handler: { (action: UIAlertAction!) -> Void in self.exitShopping() })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(exitShoppingAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    func deleteList() {
        ShoppingList.userData = nil
        viewDidLoad()
    }

    @IBAction func addItemButtonTriggered(_ sender: UIButton) {
        let alert = textFieldAlert(name: "商品を追加", placeholder: "商品名") { text in
            let newItem = OnceItem(id: UUID().uuidString, name: text, shouldBuy: true)
            self.shoppingListTableViewController.add(newItem)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func selectedCell(_ item: Item, editAction: @escaping (String) -> Void) {
        let alert = textFieldAlert(name: "商品名を編集", initName: item.name, placeholder: "商品名") { text in
            editAction(text)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldAlert(name: String, initName: String? = nil, placeholder: String, updateAction: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "保存する", style: .default) { action in
            guard let text = alert.textFields?.first?.text else { return }
            self.dismiss(animated: true) { updateAction(text) }
        }
        doneAction.isEnabled = false
        self.doneAction = doneAction
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { _ in self.dismiss(animated: true, completion: nil) }
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        alert.addTextField() { (textField) -> Void in
            textField.delegate = self
            textField.placeholder = placeholder
            textField.text = initName ?? ""
        }
        return alert
    }
}

extension ShoppingListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        doneAction?.isEnabled = !string.isEmpty
        return true
    }
}
