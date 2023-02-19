//
//  EditTitleCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/03.
//

import UIKit

class EditTitleCell: UITableViewCell {
    typealias TitleChangeAction = (String) -> Void
    private var titleChangeAction: TitleChangeAction?
    @IBOutlet var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(onExitAction(sender:)), for: .editingDidEndOnExit)
        titleTextField.becomeFirstResponder()
    }
    
    func configure(title: String, placeholder: String, titlechangeAction: @escaping TitleChangeAction) {
        titleTextField.text = title
        titleTextField.placeholder = placeholder
        self.titleChangeAction = titlechangeAction
    }

    @objc func onExitAction(sender: Any) {
        titleChangeAction?(self.titleTextField.text ?? "")
    }
}

extension EditTitleCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let originalText = textField.text {
            let title = (originalText as NSString).replacingCharacters(in: range, with: string)
            titleChangeAction?(title)
        }
        return true
    }
}
