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
    weak var viewModel: ConversationCellViewModel? {
        didSet {
            configure()
        }
    }
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .cloudSky
        return label
    }()
    
    lazy var timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .cloudSky
        return label
    }()
    
    lazy var notificationStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height/2.0
        label.textColor = .black
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var avatarImageView: AvatarGenerator = {
        let iv = AvatarGenerator(pseudoname: "", background: 0)
        iv.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        iv.layer.cornerRadius = 50/2
        return iv
    }()
        
    lazy var circle: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .heavenlyWhite
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
        self.separatorInset = .zero
        self.backgroundColor = .midnights
        let stackMessage = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stackMessage.axis = .vertical
        stackMessage.spacing = 4
        
        let stackStamp = UIStackView(arrangedSubviews: [timeStamp, circle])
        stackStamp.axis = .vertical
        stackStamp.spacing = 4
        stackStamp.alignment = .trailing

        addSubview(avatarImageView)
        addSubview(stackStamp)
        addSubview(stackMessage)
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        circle.layer.cornerRadius = 20/2
        circle.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        circle.addSubview(notificationStamp)
        notificationStamp.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        stackStamp.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(50)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        stackMessage.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.right.equalTo(stackStamp.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    func configure() {
        self.usernameLabel.text = viewModel?.pseudonameString()
        self.messageLabel.text = viewModel?.messageString()
        self.timeStamp.text = viewModel?.timestamp
        self.avatarImageView.pseudoname = viewModel?.pseudonameString()
        self.avatarImageView.randomInt = viewModel?.randomInt() ?? 0
        notificationStamp.text = viewModel?.unreadMessagesString()
        circle.isHidden = viewModel?.hiddenStatus() ?? true
    }
}
