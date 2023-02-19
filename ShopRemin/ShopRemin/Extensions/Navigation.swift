//
//  NavigationItem.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2022/02/27.
//

import UIKit

extension UINavigationItem {
    func setTitleView(withTitle title: String, subTitile: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black

        let subTitleLabel = UILabel()
        subTitleLabel.text = subTitile
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .gray

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
    }
}

extension UINavigationController {
    func showMidium() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
}
