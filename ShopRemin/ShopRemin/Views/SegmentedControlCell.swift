//
//  SegmentedControlCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/07.
//

import UIKit

class SegmentedControlCell: UITableViewCell {
    typealias ChangeAction = (Int) -> Void
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    private var changeAction: ChangeAction?
    
    func configure(title: String, values: [String], selectedIndex: Int, changeAction: @escaping ChangeAction) {
        titleLabel.text = title
        for (i,value) in values.enumerated() {
            segmentedControl.setTitle(value, forSegmentAt: i)
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
        selectionStyle = .none
        self.changeAction = changeAction
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        self.changeAction?(sender.selectedSegmentIndex)
    }
    
}
