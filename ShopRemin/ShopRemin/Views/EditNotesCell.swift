//
//  EditNoteCell.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2021/11/04.
//

import UIKit

class EditNotesCell: UITableViewCell {
    typealias NotesChangeAction = (String) -> Void
    private var notesChangeAction: NotesChangeAction?
    
    @IBOutlet var noteTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteTextView.delegate = self
    }
    
    func configure(text: String?, notesChangeAction: NotesChangeAction?) {
        noteTextView.text = text
        self.notesChangeAction = notesChangeAction
    }
    
}

extension EditNotesCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let originalText = textView.text {
            let text = (originalText as NSString).replacingCharacters(in: range, with: text)
            notesChangeAction?(text)
        }
        return true
    }
}
