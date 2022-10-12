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
//    private var viewModel = ConversationViewModel()
    var conversation: Conversation? {
        didSet {configure()}
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .cloudSky
        return label
    }()
    
    let timeStamp: UILabel = { 
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .cloudSky
        return label
    }()
    
    let notificationStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height/2.0
        label.textColor = .black
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let avatarImageView: AvatarGenerator = {
        let iv = AvatarGenerator(pseudoname: "", background: 0)
        iv.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        iv.layer.cornerRadius = 50/2
        return iv
    }()
        
    let circle: UIImageView = {
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
        guard let conversation else {
            return
        }
        let viewmodel = ConversationCellViewModel(conversation: conversation)
        self.usernameLabel.text = viewmodel.pseudonameString()
        self.messageLabel.text = viewmodel.messageString()
        self.timeStamp.text = viewmodel.timestamp
        self.avatarImageView.pseudoname = viewmodel.pseudonameString()
        self.avatarImageView.randomInt = viewmodel.randomInt()
        notificationStamp.text = String(conversation.unreadMessages)
        if conversation.unreadMessages > 0 {
            circle.isHidden = false
        }else {
            circle.isHidden = true
        }
        

    }
}
