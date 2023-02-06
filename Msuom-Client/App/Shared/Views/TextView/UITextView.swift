//
//  UITextView.swift
//
//  Created by MGAbouarab®
//

import UIKit

class TextViewContentSized: UITextView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}

class ChatTextViewContentSized: UITextView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        let height = contentSize.height < 100 ? contentSize.height : 100
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
}
