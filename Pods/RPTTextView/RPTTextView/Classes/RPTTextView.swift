
//
//  PHTextView.swift
//  FBSnapshotTestCase
//
//  Created by Arpit on 2/3/20.
//

import UIKit

class RPTTextView : UITextView, UITextViewDelegate {
    private var localTextColor : UIColor!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.localTextColor = self.textColor
        self.delegate = self
    }
    
    @IBInspectable var placeHolder : String? {
        didSet {
            if let t = self.text, t.count == 0 {
                self.text = placeHolder
            }
        }
    }
    
    @IBInspectable var placeHolderColor : UIColor? = .lightGray  {
        didSet {
            self.textColor = placeHolderColor
        }
    }
    
    @IBInspectable var characotrLimit : Int = 0
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if characotrLimit == 0 {return true}
        
        //..
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < characotrLimit    // 10 Limit Value
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeHolder {
            textView.text = ""
            textView.textColor = localTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = placeHolder
            textView.textColor = placeHolderColor
        }

    }
}
