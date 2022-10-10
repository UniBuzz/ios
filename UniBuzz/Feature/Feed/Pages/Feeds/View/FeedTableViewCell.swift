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
    func didTapComment(feed: Buzz, destination: Destination)
}

class FeedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    weak var feedDelegate: FeedCellDelegate?
    
    static var cellIdentifier = "FeedCell"
    let actionContainerColor = UIColor.rgb(red: 83, green: 83, blue: 83)
    var userUID = ""
    var parentFeed = ""
    var isUpvoted = false
    
    var cellViewModel: FeedCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            userName.text = cellViewModel.feed.userName
            content.text = cellViewModel.feed.content
            commentCount.setTitle("  \(cellViewModel.feed.commentCount)", for: .normal)
            upVoteCount.setTitle(" \(cellViewModel.feed.upvoteCount)", for: .normal)
            isUpvoted = cellViewModel.feed.isUpvoted
            self.configureCell()
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
        button.setImage(UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
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
        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
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
    
    lazy var showOrHideCommentsButton: UIButton = {
        let showOrHideCommentsButton = UIButton(frame: .zero)
        showOrHideCommentsButton.setTitle("See more", for: .normal)
        showOrHideCommentsButton.titleLabel?.font = .systemFont(ofSize: 16)
        showOrHideCommentsButton.tintColor = .heavenlyWhite
        showOrHideCommentsButton.contentHorizontalAlignment = .left
        return showOrHideCommentsButton
    }()
    
    lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    var seperatorForFeedsAndComments: UIView?
    var containerLeftAnchor = NSLayoutConstraint()
    var seperatorBottomAnchor = NSLayoutConstraint()
        
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: - Selectors
    @objc func upVotePressed() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        print(isUpvoted)
        if isUpvoted {
            cellViewModel?.feed.upvoteCount -= 1
            cellViewModel?.feed.isUpvoted = false
            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
            upVoteCount.tintColor = .heavenlyWhite
            upVoteCountContainer.backgroundColor = actionContainerColor
        } else {
            cellViewModel?.feed.upvoteCount += 1
            cellViewModel?.feed.isUpvoted = true
            upVoteCount.setTitleColor(.eternalBlack, for: .normal)
            upVoteCount.titleLabel?.textColor = .eternalBlack
            upVoteCount.tintColor = .eternalBlack
            upVoteCountContainer.backgroundColor = .creamyYellow
        }
        feedDelegate?.didTapUpVote(model: UpvoteModel(feedToVoteID: cellViewModel?.feed.feedID ?? "", currenUserID: currentUserID))
    }
    
    @objc func commentCountPressed() {
        guard let feed = cellViewModel?.feed else { return }
        print("Go To Comment Page with content of \(feed.content)")
        feedDelegate?.didTapComment(feed: feed, destination: feed.forPage)
    }
    
    @objc func sendMessagePressed() {
        guard let feed = cellViewModel?.feed else { return }
        print("send message to this id: \(feed.uid)")
        feedDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
    }
    
    //MARK: - Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func checkUpvoteButton() {
        // Refactor with rx later
        guard let feed = cellViewModel?.feed else { return }
        if userUID == feed.uid {
            upVoteCount.isEnabled = false
            sendMessageButton.isEnabled = false
        } else {
            upVoteCount.isEnabled = true
            sendMessageButton.isEnabled = true
        }
        
        if isUpvoted {
            upVoteCount.setTitleColor(.eternalBlack, for: .normal)
            upVoteCount.titleLabel?.textColor = .eternalBlack
            upVoteCount.tintColor = .eternalBlack
            upVoteCountContainer.backgroundColor = .creamyYellow
        } else {
            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
            upVoteCount.tintColor = .heavenlyWhite
            upVoteCountContainer.backgroundColor = actionContainerColor
        }
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .midnights
        self.contentView.addSubview(container)
        self.container.addSubview(userName)
        self.container.addSubview(content)
        self.container.addSubview(optionButton)
        self.container.addSubview(sendMessageButton)
        self.container.addSubview(commentCount)
        self.container.addSubview(upVoteCount)
        self.container.addSubview(verticalStack)
        verticalStack.addArrangedSubview(sendAndCommentHStack)
        
        checkUpvoteButton()
        addSeperator()
        checkBuzzType()

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

        verticalStack.snp.makeConstraints { make in
            make.left.equalTo(userName.snp.left)
            make.top.equalTo(content.snp.bottom).offset(20)
            make.bottom.equalTo(container.snp.bottom).offset(-16)
        }
    }
    
    func addSeperator() {
        if let seperator = seperatorForFeedsAndComments {
            contentView.addSubview(seperator)
            containerLeftAnchor = NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 32)
            containerLeftAnchor.isActive = true

            seperatorBottomAnchor = NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 16)
            seperatorBottomAnchor.isActive = true
            
            container.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top).offset(16)
                make.right.equalTo(contentView.snp.right).offset(-32)
            }
            
            seperator.snp.makeConstraints({ make in
                make.left.equalTo(contentView.snp.left)
                make.right.equalTo(contentView.snp.right)
                make.bottom.equalTo(contentView.snp.bottom)
                make.height.equalTo(1)
            })
        } else {
            container.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.left).offset(32)
                make.top.equalTo(contentView.snp.top).offset(32)
                make.right.equalTo(contentView.snp.right).offset(-32)
                make.bottom.equalTo(contentView.snp.bottom)
            }
        }
    }
    
    func checkBuzzType() {
        guard let feed = cellViewModel?.feed else { return }
        switch feed.buzzType {
        case .feed:
            self.container.addSubview(sendMessageButtonContainer)
            self.container.addSubview(upVoteCountContainer)
            self.container.addSubview(commentCountContainer)
            
            sendAndCommentHStack.addArrangedSubview(upVoteCountContainer)
            sendAndCommentHStack.addArrangedSubview(commentCountContainer)
            
            sendMessageButtonContainer.addSubview(sendMessageButton)
            upVoteCountContainer.addSubview(upVoteCount)
            commentCountContainer.addSubview(commentCount)
            
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
            
            sendMessageButton.snp.makeConstraints { make in
                make.top.equalTo(sendMessageButtonContainer).offset(2)
                make.left.equalTo(sendMessageButtonContainer).offset(8)
                make.right.equalTo(sendMessageButtonContainer).offset(-8)
                make.bottom.equalTo(sendMessageButtonContainer).offset(-2)
            }
        
            sendMessageButtonContainer.snp.makeConstraints { make in
                make.top.equalTo(verticalStack.snp.top)
                make.bottom.equalTo(verticalStack.snp.bottom)
                make.right.equalTo(optionButton.snp.right)
            }
        case .comment:
            sendAndCommentHStack.addArrangedSubview(upVoteCount)
            sendAndCommentHStack.addArrangedSubview(commentCount)
            container.backgroundColor = .clear
            sendAndCommentHStack.spacing = 30

            sendMessageButton.snp.makeConstraints { make in
                make.top.equalTo(verticalStack.snp.top)
                make.bottom.equalTo(verticalStack.snp.bottom)
                make.right.equalTo(optionButton.snp.right)
            }
            
            if feed.repliedFrom != parentFeed {
                containerLeftAnchor.constant = 52
                print("comment replied from child comment!")
            } else {
                verticalStack.addArrangedSubview(showOrHideCommentsButton)
                seperatorBottomAnchor.constant = 0
                print("comment replied from parent comment!")
            }
        }
    }
    
    func addShowMoreOrLessButton() {
        // if there is a comment display it
        if cellViewModel?.feed.commentCount != 0 {
            
        }
    }
}


