//
//  ConversationCell.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var conversation: Conversation? {
        didSet {configure()}
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 50/2
        stack.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure() {
        usernameLabel.text = conversation?.username
        messageLabel.text = conversation?.message
    }

}
