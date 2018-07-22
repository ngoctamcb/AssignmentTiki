//
//  TwitterVC.swift
//  Tiki
//
//  Created by Tam Tran on 7/22/18.
//  Copyright © 2018 Tam Tran. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TwitterVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UINavigationControllerDelegate {

    private let reuseIdentifier = "Cell"
    private var previousRect: CGRect?
    private var placeholderLabel : UILabel!

    var messengerList: [String] = []
    var numberMess: Int = 1


    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Montserrat-Regular", size: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.gray.cgColor

        textView.layer.masksToBounds = false
        textView.clipsToBounds = true
        textView.delegate = self
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Twitter"
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(hexString: "#F7F7F7")
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(TwitterCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        setupInputTextView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - SETUP INPUT TEXT VIEW
    func setupInputTextView() {
        previousRect = inputTextView.caretRect(for: inputTextView.endOfDocument)
    }

    // MARK: - SETUP INPUT VIEW
    var textViewHeightAnchor: NSLayoutConstraint?

    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        containerView.backgroundColor = collectionView?.backgroundColor
        //send image
        let sendImageView = UIImageView()
        sendImageView.isUserInteractionEnabled = true
        sendImageView.image = UIImage(named: "ic_send")
        sendImageView.translatesAutoresizingMaskIntoConstraints = false
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))
        sendImageView.contentMode = .scaleToFill
        containerView.addSubview(sendImageView)

        sendImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendImageView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        sendImageView.heightAnchor.constraint(equalToConstant: 42).isActive = true

        //Input text
        containerView.addSubview(self.inputTextView)
        //x,y,w,h
        self.inputTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextView.rightAnchor.constraint(equalTo: sendImageView.leftAnchor, constant: -8).isActive = true
        self.inputTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textViewHeightAnchor = self.inputTextView.heightAnchor.constraint(equalToConstant: 42)
        textViewHeightAnchor?.isActive = true

        return containerView
    }()

    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }


    //  MARK: - HANDLER TEXT CHANGE
    func textViewDidChange(_ textView: UITextView) {
//        placeholderLabel.isHidden = !textView.text.isEmpty

        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        //        print("currentRect: \(currentRect.origin.y) preRect\(previousRect?.origin.y)")
        if (currentRect.origin.y > (previousRect?.origin.y)!){
            print("break new line")
            if (textViewHeightAnchor?.constant)! < CGFloat(85) {
                textViewHeightAnchor?.constant = (textViewHeightAnchor?.constant)! + 10.0
                //                print("current height: \(String(describing: textViewHeightAnchor?.constant))")
            }
            if currentRect.origin.y > 102 {
                textViewHeightAnchor?.constant = 94
            }
        } else if (currentRect.origin.y < (previousRect?.origin.y)!) {
            print("return line")
            if (textViewHeightAnchor?.constant)! > CGFloat(44) && (currentRect.origin.y) < 103 {
                textViewHeightAnchor?.constant = (textViewHeightAnchor?.constant)! - 10.0
                //                print("current height: \(String(describing: textViewHeightAnchor?.constant))")
            }
            if currentRect.origin.y <= 7 {
                textViewHeightAnchor?.constant = 44
            }
        }
        previousRect = currentRect
    }

    //  MARK: - HANDLER SEND
    @objc func handleSend() {
       print("SEND")
        if inputTextView.text! == "" {
            return
        }
        numberMess = 1
        let messenger = inputTextView.text!
        if (messenger.count) > 50 {
            let result: [String] = split(messenger: messenger)
            for i in result {
                messengerList.append("1/\(numberMess)\(" ")\(i)")
                numberMess += 1
            }

        }else {
            messengerList.append(messenger)
        }
        collectionView?.reloadData()
        scrollToBottom()
    }

    func scrollToBottom() {
        if messengerList.count > 0 {
            let indexPath = IndexPath(item: messengerList.count - 1, section: 0)
            if indexPath.item > 0 {
                collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }

    func split(messenger: String) -> [String] {

        var arrResult :[String] = []
        var indexSplit = 46

        while indexSplit < messenger.count {
            if messenger[indexSplit] != " " {
                for j in (0..<indexSplit).reversed() {
                    if indexSplit - 46 < j {
                        if messenger[j] == " " {
                            let rs: String = messenger[indexSplit - 46..<j]
                            indexSplit = j + 1
                            arrResult.append(rs)
                            break
                        }
                    } else {
                        let rs: String = messenger[indexSplit - 46..<indexSplit]
                        arrResult.append(rs)
                        break
                    }
                }
            } else {
                let rs: String = messenger[indexSplit - 46..<indexSplit]
                indexSplit = indexSplit + 2
                arrResult.append(rs)
            }
            indexSplit = indexSplit + 46
        }
        arrResult.append(messenger[indexSplit - 46..<messenger.count])
        return arrResult
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messengerList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TwitterCell
        cell.textView.text = messengerList[indexPath.row]
        // Configure the cell

    
        return cell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let message = messengerList[indexPath.row]

        var height: CGFloat = 80
        height = estimateFrameForText(message).height + 20

        let width = UIScreen.main.bounds.width

        return CGSize(width: width, height: height)
    }

    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}

extension String {

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}
