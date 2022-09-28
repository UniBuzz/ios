//
//  FeedTableViewCell.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import UIKit
import Firebase

protocol FeedCellDelegate: AnyObject {
    func didTapMessage(uid: String, pseudoname: String)
    func didTapUpVote(model: UpvoteModel)
}

class FeedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    weak var feedDelegate: FeedCellDelegate?
    
    static var cellIdentifier = "FeedCell"
    let actionContainerColor = UIColor.rgb(red: 83, green: 83, blue: 83)
    var upVoteTapped = false
    var userUID = ""

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
        view.backgroundColor = .stoneGrey
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.text = "sampleUserName"
        label.textColor = .heavenlyWhite
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.text = "sampleContent"
        label.numberOfLines = 0
        label.textColor = .heavenlyWhite
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var upVoteCountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = actionContainerColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var upVoteCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.addTarget(self, action: #selector(upVotePressed), for: .touchUpInside)
        button.setTitle("10", for: .normal)
        button.titleLabel?.textColor = .heavenlyWhite
        button.tintColor = .heavenlyWhite
        return button
    }()
    
    lazy var commentCountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = actionContainerColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var commentCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
        button.addTarget(self, action: #selector(commentCountPressed), for: .touchUpInside)
        button.setTitle("8", for: .normal)
        button.titleLabel?.textColor = .heavenlyWhite
        button.tintColor = .heavenlyWhite
        return button
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)),
                        for: .normal)
        button.tintColor = .heavenlyWhite
        return button
    }()
    
    lazy var sendMessageButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = actionContainerColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)),
                        for: .normal)
        button.addTarget(self, action: #selector(sendMessagePressed), for: .touchUpInside)
        button.tintColor = .heavenlyWhite
        return button
    }()
    
    lazy var sendAndCommentHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
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
    
    //MARK: - Selectors
    @objc func upVotePressed() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
                
        if upVoteTapped {
            feed?.upvoteCount -= 1
            upVoteTapped = false
            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
            upVoteCount.tintColor = .heavenlyWhite
            upVoteCountContainer.backgroundColor = actionContainerColor
        } else {
            feed?.upvoteCount += 1
            upVoteTapped = true
            upVoteCount.setTitleColor(.eternalBlack, for: .normal)
            upVoteCount.titleLabel?.textColor = .eternalBlack
            upVoteCount.tintColor = .eternalBlack
            upVoteCountContainer.backgroundColor = .creamyYellow
        }
        feedDelegate?.didTapUpVote(model: UpvoteModel(feedID: feed?.feedID ?? ""
                                                      , userID: currentUserID))
    }
    
    @objc func commentCountPressed() {
        print("Go To Comment Page with content of \(feed?.content)")
    }
    
    @objc func sendMessagePressed() {
        print("send message to this id: \(feed?.uid)")
        if let feed {
            feedDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
        }
    }
    
    //MARK: - Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .midnights
        self.contentView.addSubview(container)
        self.container.addSubview(userName)
        self.container.addSubview(content)
        self.container.addSubview(optionButton)
        self.container.addSubview(sendMessageButton)
        self.container.addSubview(sendAndCommentHStack)
        self.container.addSubview(sendMessageButtonContainer)
        self.container.addSubview(upVoteCountContainer)
        self.container.addSubview(commentCountContainer)
        
        sendMessageButtonContainer.addSubview(sendMessageButton)
        upVoteCountContainer.addSubview(upVoteCount)
        commentCountContainer.addSubview(commentCount)
        
        sendAndCommentHStack.addArrangedSubview(upVoteCountContainer)
        sendAndCommentHStack.addArrangedSubview(commentCountContainer)

        container.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(32)
            make.top.equalTo(contentView.snp.top).offset(32)
            make.right.equalTo(contentView.snp.right).offset(-32)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        userName.snp.makeConstraints { make in
            make.left.equalTo(container.snp.left).offset(15)
            make.top.equalTo(container.snp.top).offset(13)
        }
        
        optionButton.snp.makeConstraints { make in
            make.right.equalTo(container.snp.right).offset(-10)
            make.top.equalTo(userName.snp.top)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(15)
            make.left.equalTo(userName.snp.left)
            make.right.equalTo(container.snp.right).offset(-50)
        }
        
        sendAndCommentHStack.snp.makeConstraints { make in
            make.left.equalTo(userName.snp.left)
            make.top.equalTo(content.snp.bottom).offset(20)
            make.bottom.equalTo(container.snp.bottom).offset(-16)
        }
        
        upVoteCount.snp.makeConstraints { make in
            make.top.equalTo(upVoteCountContainer.snp.top).offset(2)
            make.left.equalTo(upVoteCountContainer.snp.left).offset(8)
            make.bottom.equalTo(upVoteCountContainer.snp.bottom).offset(-2)
            make.right.equalTo(upVoteCountContainer.snp.right).offset(-8)
        }
        
        commentCount.snp.makeConstraints { make in
            make.top.equalTo(commentCountContainer.snp.top).offset(2)
            make.left.equalTo(commentCountContainer.snp.left).offset(8)
            make.bottom.equalTo(commentCountContainer.snp.bottom).offset(-2)
            make.right.equalTo(commentCountContainer.snp.right).offset(-8)
        }
        
        sendMessageButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(sendAndCommentHStack.snp.top)
            make.bottom.equalTo(sendAndCommentHStack.snp.bottom)
            make.right.equalTo(container.snp.right).offset(-20)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.top.equalTo(sendMessageButtonContainer).offset(2)
            make.left.equalTo(sendMessageButtonContainer).offset(8)
            make.right.equalTo(sendMessageButtonContainer).offset(-8)
            make.bottom.equalTo(sendMessageButtonContainer).offset(-2)
        }
        
    }

}
