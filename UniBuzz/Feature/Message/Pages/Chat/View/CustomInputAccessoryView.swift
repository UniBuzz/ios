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
        tv.autocorrectionType = .no
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
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
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(8)
            make.height.equalTo(50)
            make.width.equalTo(75)
        }
        
        addSubview(messageInputTextView)
        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(4)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(8)
            make.right.equalTo(sendButton.snp.left).offset(8)
        }
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(messageInputTextView.snp.left).offset(4)
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
