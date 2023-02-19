//
//  ItemListContainerViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/12/08.
//

import UIKit

class ItemListContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "定期購入品一覧"
    }
    
    @IBAction func addNewItemButtonTriggered(_ sender: UIButton) {
        let itemListViewController = self.children[0] as! ItemListViewController
        itemListViewController.createAddItemView()
    }
}
