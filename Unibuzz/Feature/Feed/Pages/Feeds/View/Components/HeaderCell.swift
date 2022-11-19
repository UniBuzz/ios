//
//  Header.swift
//  Unibuzz
//
//  Created by hada.muhammad on 19/11/22.
//

import UIKit
import SnapKit

class HeaderCell: UIView {
    
    internal weak var optionButtonPressedDelegate: OptionButtonPressedDelegate?
    internal var viewModel: FeedCellViewModel?
    
    lazy var avatarImageView: AvatarGenerator = {
        let avatarImageView = AvatarGenerator(pseudoname: "", background: 0)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        avatarImageView.layer.cornerRadius = 24/2
        avatarImageView.nameLabel.font = .systemFont(ofSize: 10)
        return avatarImageView
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.text = "sampleUserName"
        label.textColor = .heavenlyWhite
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.tintColor = .heavenlyWhite
        button.addTarget(self, action: #selector(handleOption), for: .touchUpInside)
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.rgb(red: 171, green: 171, blue: 171)
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView()
        addSubview(stack)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.addArrangedSubview(avatarImageView)
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(timeLabel)
        
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(stack.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleOption() {
        guard let feed = viewModel?.feed else { return }
        optionButtonPressedDelegate?.optionButtonHandler(feed: feed)
    }
}
