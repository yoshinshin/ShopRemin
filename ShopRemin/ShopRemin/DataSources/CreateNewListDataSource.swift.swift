//
//  CreateNewListDataSource.swift.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/17.
//

import UIKit

class CreateNewListDataSource: NSObject {
    typealias ShoppingListChangeAction = (ShoppingList) -> Void
    
    enum Section: CaseIterable {
        case name
        case shoppingDate
        
        var cellIdentifier: String {
            switch self {
            case .name:
                return "EditTitleCell"
            case .shoppingDate:
                return "DatePickerCell"
            }
        }
    }
    
    private var shoppingList: ShoppingList
    private var isList: Bool = true
    private var shoppingListChangeAction: ShoppingListChangeAction
    private var cellType: [Section] {
        return isList ? Section.allCases : [.shoppingDate]
    }
    
    init(_ shoppingList: ShoppingList, isList: Bool, changeAction: @escaping ShoppingListChangeAction) {
        self.shoppingList = shoppingList
        self.shoppingListChangeAction = changeAction
        self.isList = isList
        super .init()
    }
    
    
}

extension CreateNewListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = cellType[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        if let titleCell = cell as? EditTitleCell {
            titleCell.configure(title: shoppingList.title, placeholder: "リスト名") { title in
                self.shoppingList.title = title
                self.shoppingListChangeAction(self.shoppingList)
            }
        }
        if let dateCell = cell as? DatePickerCell {
            dateCell.configure(date: shoppingList.shoppingDate, minimumDate: Date()) { date in
                self.shoppingList.shoppingDate = date
                self.shoppingListChangeAction(self.shoppingList)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "買い物に行く日付" : nil
    }
}
