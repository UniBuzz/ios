//
//  FeedTableViewCell.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.text = "sampleUserName"
        return label
    }()
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.text = "sampleContent"
        return label
    }()
    
    lazy var upVoteCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.setTitle("10", for: .normal)
        return button
    }()
    
    lazy var commentCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setTitle("8", for: .normal)
        return button
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setTitle("􀍠", for: .normal)
        return button
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
        return button
    }()
    
    lazy var sendAndCommentHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    static var cellIdentifier = "FeedCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        self.contentView.addSubview(userName)
        self.contentView.addSubview(content)
        self.contentView.addSubview(optionButton)
        self.contentView.addSubview(sendMessageButton)
        self.contentView.addSubview(sendAndCommentHStack)
        
        sendAndCommentHStack.addArrangedSubview(upVoteCount)
        sendAndCommentHStack.addArrangedSubview(commentCount)

        userName.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
        }
        
        optionButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(userName.snp.top)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(10)
            make.left.equalTo(userName.snp.left)
            make.right.equalTo(optionButton.snp.left)
        }
        
        sendAndCommentHStack.snp.makeConstraints { make in
            make.left.equalTo(userName.snp.left)
            make.top.equalTo(content.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.left.equalTo(sendAndCommentHStack.snp.right).offset(20)
            make.top.equalTo(sendAndCommentHStack.snp.top)
            make.bottom.equalTo(sendAndCommentHStack.snp.bottom)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
    }

}
