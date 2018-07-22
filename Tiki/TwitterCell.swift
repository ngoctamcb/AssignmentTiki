//
//  TwitterCell.swift
//  Tiki
//
//  Created by Tam Tran on 7/22/18.
//  Copyright © 2018 Tam Tran. All rights reserved.
//

import UIKit

class TwitterCell: UICollectionViewCell, UITextViewDelegate {

        var message: String?

        lazy var textView: UITextView = {
            let tv = UITextView()
            tv.text = "SAMPLE TEXT FOR NOW"
            tv.isEditable = false
            tv.isSelectable = true
            tv.delegate = self
            tv.dataDetectorTypes = [.link, .phoneNumber]
            let linkAttributes: [String : Any] = [
                NSAttributedStringKey.foregroundColor.rawValue: UIColor.orange,
                NSAttributedStringKey.underlineColor.rawValue: UIColor.lightGray,
                NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
            tv.linkTextAttributes = linkAttributes
            tv.isUserInteractionEnabled = true
            tv.font = UIFont(name: "Montserrat-Regular", size: 14)

            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = UIColor.clear
            tv.textColor = .white
            return tv
        }()

        let bubbleView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hexString: "#27B1E5")
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            return view
        }()

        var bubbleWidthAnchor: NSLayoutConstraint?
        var bubbleViewRightAnchor: NSLayoutConstraint?
        var bubbleViewLeftAnchor: NSLayoutConstraint?

        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(bubbleView)
            addSubview(textView)

            //x,y,w,h
            bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
            bubbleViewRightAnchor?.isActive = true
            bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 8)
            //        bubbleViewLeftAnchor?.active = false

            bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
            bubbleWidthAnchor?.isActive = true
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

            //x,y,w,h
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
            textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
            textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            print("LINK")
            return true
        }
}
