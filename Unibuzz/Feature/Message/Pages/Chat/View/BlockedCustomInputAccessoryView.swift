//
//  BlockedCustomInputAccessoryView.swift
//  Unibuzz
//
//  Created by Kevin ahmad on 08/11/22.
//


import UIKit
import SnapKit


class BlockedCustomInputAccessoryView: UIView {

    // MARK: - properties    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Kamu sudah tidak bisa mengobrol dengan orang ini."
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .heavenlyWhite
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .eternalBlack
        return view
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

        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(placeholderLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(40)
        }
    }

}
