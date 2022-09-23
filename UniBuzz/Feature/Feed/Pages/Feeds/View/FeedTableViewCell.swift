//
//  FeedTableViewCell.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static var cellIdentifier = "FeedCell"

    var feed: FeedModel? {
        didSet {
            guard let feed = feed else {return}
            userName.text = feed.userName
            content.text = feed.content
            upVoteCount.setTitle(String(feed.upvoteCount), for: .normal)
            commentCount.setTitle(String(feed.commentCount), for: .normal)
        }
    }
    
    //MARK: - UIElements
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.text = "sampleUserName"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.text = "sampleContent"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var upVoteCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.setTitle(" 10", for: .normal)
//        button.titleLabel?.textColor = .white
        button.tintColor = .white
        return button
    }()
    
    lazy var commentCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
        button.setTitle(" 8", for: .normal)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        return button
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)),
                        for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)),
                        for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var sendAndCommentHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
        
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        self.contentView.addSubview(container)
        self.container.addSubview(userName)
        self.container.addSubview(content)
        self.container.addSubview(optionButton)
        self.container.addSubview(sendMessageButton)
        self.container.addSubview(sendAndCommentHStack)
        
        sendAndCommentHStack.addArrangedSubview(upVoteCount)
        sendAndCommentHStack.addArrangedSubview(commentCount)

        container.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        userName.snp.makeConstraints { make in
            make.left.equalTo(container.snp.left).offset(10)
            make.top.equalTo(container.snp.top).offset(10)
        }
        
        optionButton.snp.makeConstraints { make in
            make.right.equalTo(container.snp.right).offset(-10)
            make.top.equalTo(userName.snp.top)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(10)
            make.left.equalTo(userName.snp.left)
            make.right.equalTo(optionButton.snp.left)
        }

        sendAndCommentHStack.snp.makeConstraints { make in
            make.left.equalTo(userName.snp.left)
            make.top.equalTo(content.snp.bottom).offset(20)
            make.bottom.equalTo(container.snp.bottom).offset(-10)
        }

        sendMessageButton.snp.makeConstraints { make in
            make.top.equalTo(sendAndCommentHStack.snp.top)
            make.bottom.equalTo(sendAndCommentHStack.snp.bottom)
            make.right.equalTo(container.snp.right).offset(-20)
        }
        
    }

}
