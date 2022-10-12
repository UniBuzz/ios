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
    func didTapComment(feed: Buzz)
}

protocol CommentCellDelegate: FeedCellDelegate {
    func didTapShowComments(from commentID: String, at index: IndexPath)
    func didTapHideComments(from commentID: String, at index: IndexPath)
}

class FeedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    weak var feedDelegate: FeedCellDelegate?
    weak var commentDelegate: CommentCellDelegate?
    static var cellIdentifier = "FeedCell"
    let actionContainerColor = UIColor.rgb(red: 83, green: 83, blue: 83)
    var userUID = ""
    var parentFeed = ""
    var isUpvoted = false
    var indexPath: IndexPath?
    var isCommentShown = false
    
    var cellViewModel: FeedCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            userName.text = cellViewModel.feed.userName
            content.text = cellViewModel.feed.content
            commentCount.setTitle("  \(cellViewModel.feed.commentCount)", for: .normal)
            upVoteCount.setTitle(" \(cellViewModel.feed.upvoteCount)", for: .normal)
            isUpvoted = cellViewModel.feed.isUpvoted
            indexPath = cellViewModel.indexPath
            isCommentShown = cellViewModel.feed.isChildCommentShown
            self.configureCell()
        }
    }
    
    //MARK: - UIElements
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .stoneGrey
        view.layer.cornerRadius = 15
//        view.backgroundColor = .warningRed
        return view
    }()
    
    lazy var mainStack: UIStackView = {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 20
        return mainStack
    }()
    
    lazy var containerStack: UIStackView = {
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        return containerStack
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
        return stack
    }()
    
    lazy var showOrHideCommentsButton: UIButton = {
        let showOrHideCommentsButton = UIButton(frame: .zero)
        showOrHideCommentsButton.setTitle("-", for: .normal)
        showOrHideCommentsButton.titleLabel?.font = .systemFont(ofSize: 16)
        showOrHideCommentsButton.tintColor = .heavenlyWhite
        showOrHideCommentsButton.contentHorizontalAlignment = .left
        showOrHideCommentsButton.addTarget(self, action: #selector(showOrHideComments), for: .touchUpInside)
        return showOrHideCommentsButton
    }()
    
    let hstack1 = UIStackView()
    let hstack2 = UIStackView()
    let miniStack2 = UIStackView()
    
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
//        print("Go To Comment Page with content of \(feed.content)")
        feedDelegate?.didTapComment(feed: feed)
    }
    
    @objc func sendMessagePressed() {
        guard let feed = cellViewModel?.feed else { return }
//        print("send message to this id: \(feed.uid)")
        feedDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
    }
    
    //MARK: - Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        print(indexPath?.row)
    }
    
    func checkUpvoteButton() {
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
        self.contentView.addSubview(containerStack)
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(16)
            make.left.equalTo(self.contentView.snp.left).offset(36)
            make.right.equalTo(self.contentView.snp.right).offset(-36)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
        }
        
        containerStack.addArrangedSubview(container)
        container.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(self.container.snp.top).offset(20)
            make.left.equalTo(self.container.snp.left).offset(20)
            make.right.equalTo(self.container.snp.right).offset(-20)
            make.bottom.equalTo(self.container.snp.bottom).offset(-20)
        }
        
        upVoteCountContainer.addSubview(upVoteCount)
        upVoteCount.snp.makeConstraints { make in
            make.top.equalTo(upVoteCountContainer).offset(4)
            make.left.equalTo(upVoteCountContainer).offset(8)
            make.right.equalTo(upVoteCountContainer).offset(-8)
            make.bottom.equalTo(upVoteCountContainer).offset(-4)
        }
        
        commentCountContainer.addSubview(commentCount)
        commentCount.snp.makeConstraints { make in
            make.top.equalTo(commentCountContainer).offset(4)
            make.left.equalTo(commentCountContainer).offset(8)
            make.right.equalTo(commentCountContainer).offset(-8)
            make.bottom.equalTo(commentCountContainer).offset(-4)
        }
        
        sendMessageButtonContainer.addSubview(sendMessageButton)
        sendMessageButton.snp.makeConstraints { make in
            make.top.equalTo(sendMessageButtonContainer).offset(4)
            make.left.equalTo(sendMessageButtonContainer).offset(8)
            make.right.equalTo(sendMessageButtonContainer).offset(-8)
            make.bottom.equalTo(sendMessageButtonContainer).offset(-4)
        }

        
        hstack1.axis = .horizontal
        hstack1.addArrangedSubview(userName)
        hstack1.addArrangedSubview(optionButton)
        
        miniStack2.axis = .horizontal
        miniStack2.addArrangedSubview(upVoteCountContainer)
        miniStack2.addArrangedSubview(commentCountContainer)
        miniStack2.spacing = 20
        
        hstack2.axis = .horizontal
        hstack2.addArrangedSubview(miniStack2)
        hstack2.addArrangedSubview(sendMessageButtonContainer)
        hstack2.distribution = .equalSpacing
        
        mainStack.addArrangedSubview(hstack1)
        mainStack.addArrangedSubview(content)
        mainStack.addArrangedSubview(hstack2)
        
//        addSeperator()
        checkUpvoteButton()
        checkBuzzType()
    }
    
    func addSeperator() {
        containerLeftAnchor = NSLayoutConstraint(item: containerStack, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 32)
        containerLeftAnchor.isActive = true
        
        if let seperator = seperatorForFeedsAndComments {
            contentView.addSubview(seperator)
            
            container.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top).offset(16)
                make.right.equalTo(contentView.snp.right).offset(-32)
            }
            
            seperator.snp.makeConstraints({ make in
                make.left.equalTo(contentView.snp.left)
                make.right.equalTo(contentView.snp.right)
                make.top.equalTo(container.snp.bottom).offset(16)
                make.bottom.equalTo(contentView.snp.bottom)
                make.height.equalTo(1)
            })
        } else {
            container.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top).offset(32)
                make.right.equalTo(contentView.snp.right).offset(-32)
                make.bottom.equalTo(contentView.snp.bottom)
            }
        }
    }
    
    func checkBuzzType() {
        guard let feed = cellViewModel?.feed else { return }
        
        if feed.isChildCommentShown {
            showOrHideCommentsButton.setTitle("See less", for: .normal)
        } else {
            showOrHideCommentsButton.setTitle("See more", for: .normal)
        }
        
        switch feed.buzzType {
        case .feed:
            container.backgroundColor = .stoneGrey
            sendMessageButtonContainer.backgroundColor = actionContainerColor
            commentCountContainer.backgroundColor = actionContainerColor
            upVoteCountContainer.backgroundColor = actionContainerColor
            commentCountContainer.isHidden = false
            mainStack.removeArrangedSubview(showOrHideCommentsButton)
            showOrHideCommentsButton.removeFromSuperview()
        case .comment:
            container.backgroundColor = .clear
            sendMessageButtonContainer.backgroundColor = .clear
            commentCountContainer.backgroundColor = .clear
            upVoteCountContainer.backgroundColor = .clear
            commentCountContainer.isHidden = false
            if cellViewModel?.feed.commentCount != 0 {
                mainStack.addArrangedSubview(showOrHideCommentsButton)
            } else {
                mainStack.removeArrangedSubview(showOrHideCommentsButton)
                showOrHideCommentsButton.removeFromSuperview()
            }
        case .childComment:
            container.backgroundColor = .clear
            sendMessageButtonContainer.backgroundColor = .clear
            commentCountContainer.backgroundColor = .clear
            upVoteCountContainer.backgroundColor = .clear
            commentCountContainer.isHidden = true
            mainStack.removeArrangedSubview(showOrHideCommentsButton)
            showOrHideCommentsButton.removeFromSuperview()
        }
    }
    
    func addShowMoreOrLessButton() {
        // if there is a comment display it
        if cellViewModel?.feed.commentCount != 0 {
            mainStack.addArrangedSubview(showOrHideCommentsButton)
        } else {
            mainStack.removeArrangedSubview(showOrHideCommentsButton)
            showOrHideCommentsButton.removeFromSuperview()
        }
    }
    
    @objc func showOrHideComments() {
        guard let cellViewModel = cellViewModel else { return }
        guard let indexPath = indexPath else { return }
        isCommentShown.toggle()
        if isCommentShown {
            showOrHideCommentsButton.setTitle("See less", for: .normal)
            commentDelegate?.didTapShowComments(from: cellViewModel.feed.feedID, at: indexPath)
        } else {
            showOrHideCommentsButton.setTitle("See more", for: .normal)
            commentDelegate?.didTapHideComments(from: cellViewModel.feed.feedID, at: indexPath)
        }
    }
}


