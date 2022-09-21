//
//  CustomInputAccessoryView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import UIKit
import SnapKit

class CustomInputAccessoryView: UIView {

    // MARK: - properties
    private lazy var messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .midnights
        tv.autocorrectionType = .no
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 15
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 9)
        button.tintColor = .midnights
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .creamyYellow
        button.layer.cornerRadius = 35/2
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Aa"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    // MARK: - Functions
    func configureUI() {
        backgroundColor = .eternalBlack
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(35)
        }
        
        addSubview(messageInputTextView)
        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(4)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            make.right.equalTo(sendButton.snp.left).offset(-20)
            make.height.greaterThanOrEqualTo(35)
        }
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(messageInputTextView.snp.left).offset(15)
            make.top.equalTo(messageInputTextView).offset(8)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    @objc func handleSendMessage() {
        print(messageInputTextView.text as Any)
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
}
