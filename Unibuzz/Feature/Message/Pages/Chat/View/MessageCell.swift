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
    var message: Message? {
        didSet {
            configureText()
        }
    }
    
    lazy var bubbleLeftAnchor = NSLayoutConstraint()
    lazy var bubbleRightAnchor = NSLayoutConstraint()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .eternalBlack
        return tv
    }()
    
    lazy var bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .creamyYellow
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.backgroundColor = .clear
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
        }
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(bubbleContainer.snp.top).offset(4)
            make.left.equalTo(bubbleContainer.snp.left).offset(12)
            make.bottom.equalTo(bubbleContainer.snp.bottom).offset(-4)
            make.right.equalTo(bubbleContainer.snp.right).offset(-12)
        }
    }
    
    func configureText() {
        guard let message = message else { return  }
        textView.text = message.text
        
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
    }
}
