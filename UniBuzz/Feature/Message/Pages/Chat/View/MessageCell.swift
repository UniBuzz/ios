//
//  MessageCell.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/09/22.
//

import UIKit
import SnapKit

class MessageCell: UICollectionViewCell {
    
    //MARK: - Properties
    var message:Message? {
        didSet {
            configureText()
        }
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .eternalBlack
        return tv
    }()
    
    private let bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .creamyYellow
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers

    func configureUI() {
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 15
        bubbleContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
            make.right.equalToSuperview().offset(-12)
        }
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(bubbleContainer.snp.top).offset(4)
            make.left.equalTo(bubbleContainer.snp.left).offset(12)
            make.bottom.equalTo(bubbleContainer.snp.bottom).offset(-4)
            make.right.equalTo(bubbleContainer.snp.right).offset(-12)
        }
    }
    
    func configureText() {
        textView.text = message?.text
    }
}
