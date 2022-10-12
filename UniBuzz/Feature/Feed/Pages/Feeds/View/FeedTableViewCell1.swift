////
////  FeedTableViewCell.swift
////  UniBuzz
////
////  Created by Hada Melino Muhammad on 20/09/22.
////
//
//import UIKit
//import Firebase
//
//protocol FeedCellDelegate: AnyObject {
//    func didTapMessage(uid: String, pseudoname: String)
//    func didTapUpVote(model: UpvoteModel)
//    func didTapComment(feed: Buzz)
//}
//
//protocol CommentCellDelegate: FeedCellDelegate {
//    func didTapShowComments(from commentID: String, at index: IndexPath)
//    func didTapHideComments(from commentID: String, at index: IndexPath)
//}
//
//class FeedTableViewCell: UITableViewCell {
//    
//    //MARK: - Variables
//    weak var feedDelegate: FeedCellDelegate?
//    weak var commentDelegate: CommentCellDelegate?
//    static var cellIdentifier = "FeedCell"
//    let actionContainerColor = UIColor.rgb(red: 83, green: 83, blue: 83)
//    var userUID = ""
//    var parentFeed = ""
//    var isUpvoted = false
//    var commentsIsShown = false
//    var indexPath: IndexPath?
//    
//    var cellViewModel: FeedCellViewModel? {
//        didSet {
//            guard let cellViewModel = cellViewModel else { return }
//            userName.text = cellViewModel.feed.userName
//            content.text = cellViewModel.feed.content
//            commentCount.setTitle("  \(cellViewModel.feed.commentCount)", for: .normal)
//            upVoteCount.setTitle(" \(cellViewModel.feed.upvoteCount)", for: .normal)
//            isUpvoted = cellViewModel.feed.isUpvoted
//            indexPath = cellViewModel.indexPath
//            self.configureCell()
//        }
//    }
//    
//    //MARK: - UIElements
//    lazy var container: UIView = {
//        let view = UIView()
//        view.backgroundColor = .stoneGrey
//        view.layer.cornerRadius = 15
//        return view
//    }()
//    
//    lazy var userName: UILabel = {
//        let label = UILabel()
//        label.text = "sampleUserName"
//        label.textColor = .heavenlyWhite
//        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        return label
//    }()
//    
//    lazy var content: UILabel = {
//        let label = UILabel()
//        label.text = "sampleContent"
//        label.numberOfLines = 0
//        label.textColor = .heavenlyWhite
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//    
//    lazy var upVoteCountContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = actionContainerColor
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    lazy var upVoteCount: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
//        button.addTarget(self, action: #selector(upVotePressed), for: .touchUpInside)
//        button.setTitle("10", for: .normal)
//        button.titleLabel?.textColor = .heavenlyWhite
//        button.tintColor = .heavenlyWhite
//        return button
//    }()
//    
//    lazy var commentCountContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = actionContainerColor
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    lazy var commentCount: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
//        button.addTarget(self, action: #selector(commentCountPressed), for: .touchUpInside)
//        button.setTitle("8", for: .normal)
//        button.titleLabel?.textColor = .heavenlyWhite
//        button.tintColor = .heavenlyWhite
//        return button
//    }()
//    
//    lazy var optionButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)),
//                        for: .normal)
//        button.tintColor = .heavenlyWhite
//        return button
//    }()
//    
//    lazy var sendMessageButtonContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = actionContainerColor
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    lazy var sendMessageButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "envelope", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)),
//                        for: .normal)
//        button.addTarget(self, action: #selector(sendMessagePressed), for: .touchUpInside)
//        button.tintColor = .heavenlyWhite
//        return button
//    }()
//    
//    lazy var sendAndCommentHStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 10
//        return stack
//    }()
//    
//    lazy var showOrHideCommentsButton: UIButton = {
//        let showOrHideCommentsButton = UIButton(frame: .zero)
//        showOrHideCommentsButton.setTitle("See more", for: .normal)
//        showOrHideCommentsButton.titleLabel?.font = .systemFont(ofSize: 16)
//        showOrHideCommentsButton.tintColor = .heavenlyWhite
//        showOrHideCommentsButton.contentHorizontalAlignment = .left
//        showOrHideCommentsButton.addTarget(self, action: #selector(showOrHideComments), for: .touchUpInside)
//        return showOrHideCommentsButton
//    }()
//    
//    lazy var verticalStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 5
//        return stack
//    }()
//    
//    var seperatorForFeedsAndComments: UIView?
//    var containerLeftAnchor = NSLayoutConstraint()
//    var seperatorBottomAnchor = NSLayoutConstraint()
//        
//    //MARK: - Lifecycle
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//    }
//    
//    //MARK: - Selectors
//    @objc func upVotePressed() {
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        print(isUpvoted)
//        if isUpvoted {
//            cellViewModel?.feed.upvoteCount -= 1
//            cellViewModel?.feed.isUpvoted = false
//            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
//            upVoteCount.tintColor = .heavenlyWhite
//            upVoteCountContainer.backgroundColor = actionContainerColor
//        } else {
//            cellViewModel?.feed.upvoteCount += 1
//            cellViewModel?.feed.isUpvoted = true
//            upVoteCount.setTitleColor(.eternalBlack, for: .normal)
//            upVoteCount.titleLabel?.textColor = .eternalBlack
//            upVoteCount.tintColor = .eternalBlack
//            upVoteCountContainer.backgroundColor = .creamyYellow
//        }
//        feedDelegate?.didTapUpVote(model: UpvoteModel(feedToVoteID: cellViewModel?.feed.feedID ?? "", currenUserID: currentUserID))
//    }
//    
//    @objc func commentCountPressed() {
//        guard let feed = cellViewModel?.feed else { return }
////        print("Go To Comment Page with content of \(feed.content)")
//        feedDelegate?.didTapComment(feed: feed)
//    }
//    
//    @objc func sendMessagePressed() {
//        guard let feed = cellViewModel?.feed else { return }
////        print("send message to this id: \(feed.uid)")
//        feedDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
//    }
//    
//    //MARK: - Functions
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//        print(indexPath?.row)
//    }
//    
//    func checkUpvoteButton() {
//        guard let feed = cellViewModel?.feed else { return }
//        if userUID == feed.uid {
//            upVoteCount.isEnabled = false
//            sendMessageButton.isEnabled = false
//        } else {
//            upVoteCount.isEnabled = true
//            sendMessageButton.isEnabled = true
//        }
//        
//        if isUpvoted {
//            upVoteCount.setTitleColor(.eternalBlack, for: .normal)
//            upVoteCount.titleLabel?.textColor = .eternalBlack
//            upVoteCount.tintColor = .eternalBlack
//            upVoteCountContainer.backgroundColor = .creamyYellow
//        } else {
//            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
//            upVoteCount.tintColor = .heavenlyWhite
//            upVoteCountContainer.backgroundColor = actionContainerColor
//        }
//    }
//    
//    func configureCell() {
//        self.contentView.backgroundColor = .midnights
//        self.contentView.addSubview(container)
//        self.container.addSubview(userName)
//        self.container.addSubview(content)
//        self.container.addSubview(optionButton)
//        self.container.addSubview(verticalStack)
//        self.container.addSubview(sendMessageButtonContainer)
//        self.container.addSubview(upVoteCountContainer)
//        self.container.addSubview(commentCountContainer)
//        sendMessageButtonContainer.addSubview(sendMessageButton)
//        upVoteCountContainer.addSubview(upVoteCount)
//        commentCountContainer.addSubview(commentCount)
//        sendAndCommentHStack.addArrangedSubview(upVoteCountContainer)
//        sendAndCommentHStack.addArrangedSubview(commentCountContainer)
//        verticalStack.addArrangedSubview(sendAndCommentHStack)
//        
//        userName.snp.makeConstraints { make in
//            make.left.equalTo(container.snp.left).offset(15)
//            make.top.equalTo(container.snp.top).offset(13)
//            make.right.equalTo(optionButton.snp.left).offset(10)
//        }
//        
//        optionButton.snp.makeConstraints { make in
//            make.right.equalTo(container.snp.right).offset(-10)
//            make.top.equalTo(userName.snp.top)
//        }
//        
//        content.snp.makeConstraints { make in
//            make.top.equalTo(userName.snp.bottom).offset(15)
//            make.left.equalTo(userName.snp.left)
//            make.right.equalTo(container.snp.right).offset(-50)
//        }
//
//        verticalStack.snp.makeConstraints { make in
//            make.left.equalTo(userName.snp.left)
//            make.top.equalTo(content.snp.bottom).offset(20)
//            make.bottom.equalTo(container.snp.bottom).offset(-16)
//        }
//
//        upVoteCount.snp.makeConstraints { make in
//            make.top.equalTo(upVoteCountContainer.snp.top).offset(4)
//            make.left.equalTo(upVoteCountContainer.snp.left).offset(4)
//            make.bottom.equalTo(upVoteCountContainer.snp.bottom).offset(-4)
//            make.right.equalTo(upVoteCountContainer.snp.right).offset(-4)
//        }
//        
//        commentCount.snp.makeConstraints { make in
//            make.top.equalTo(commentCountContainer.snp.top).offset(4)
//            make.left.equalTo(commentCountContainer.snp.left).offset(4)
//            make.bottom.equalTo(commentCountContainer.snp.bottom).offset(-4)
//            make.right.equalTo(commentCountContainer.snp.right).offset(-4)
//        }
//        
//        sendMessageButton.snp.makeConstraints { make in
//            make.top.equalTo(sendMessageButtonContainer).offset(4)
//            make.left.equalTo(sendMessageButtonContainer).offset(4)
//            make.right.equalTo(sendMessageButtonContainer).offset(-4)
//            make.bottom.equalTo(sendMessageButtonContainer).offset(-4)
//        }
//    
//        sendMessageButtonContainer.snp.makeConstraints { make in
//            make.top.equalTo(verticalStack.snp.top)
//            make.bottom.equalTo(verticalStack.snp.bottom)
//            make.right.equalTo(optionButton.snp.right)
//        }
//        
//        addSeperator()
//        checkUpvoteButton()
//        checkBuzzType()
//    }
//    
//    func addSeperator() {
//        containerLeftAnchor = NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 32)
//        containerLeftAnchor.isActive = true
//        
//        if let seperator = seperatorForFeedsAndComments {
//            contentView.addSubview(seperator)
//            
//            container.snp.makeConstraints { make in
//                make.top.equalTo(contentView.snp.top).offset(16)
//                make.right.equalTo(contentView.snp.right).offset(-32)
//            }
//            
//            seperator.snp.makeConstraints({ make in
//                make.left.equalTo(contentView.snp.left)
//                make.right.equalTo(contentView.snp.right)
//                make.top.equalTo(container.snp.bottom).offset(16)
//                make.bottom.equalTo(contentView.snp.bottom)
//                make.height.equalTo(1)
//            })
//        } else {
//            container.snp.makeConstraints { make in
//                make.top.equalTo(contentView.snp.top).offset(32)
//                make.right.equalTo(contentView.snp.right).offset(-32)
//                make.bottom.equalTo(contentView.snp.bottom)
//            }
//        }
//    }
//    
//    func checkBuzzType() {
//        guard let feed = cellViewModel?.feed else { return }
//        
//        if feed.buzzType != .feed {
//            container.backgroundColor = .clear
//            sendMessageButtonContainer.backgroundColor = .clear
//            commentCountContainer.backgroundColor = .clear
//            upVoteCountContainer.backgroundColor = .clear
//            sendAndCommentHStack.spacing = 30
//            addShowMoreOrLessButton()
//            if feed.buzzType == .childComment {
//                containerLeftAnchor.constant = 60
//                commentCount.isHidden = true
//            }
//        }
//    }
//    
//    func addShowMoreOrLessButton() {
//        // if there is a comment display it
//        if cellViewModel?.feed.commentCount != 0 {
//            verticalStack.addArrangedSubview(showOrHideCommentsButton)
//        }
//    }
//    
//    @objc func showOrHideComments() {
//        guard let cellViewModel = cellViewModel else { return }
//        guard let indexPath = indexPath else { return }
//        print(indexPath.row)
//        commentsIsShown.toggle()
//        if commentsIsShown {
//            showOrHideCommentsButton.setTitle("See less", for: .normal)
//            commentDelegate?.didTapShowComments(from: cellViewModel.feed.feedID, at: indexPath)
//        } else {
//            showOrHideCommentsButton.setTitle("See more", for: .normal)
//            commentDelegate?.didTapHideComments(from: cellViewModel.feed.feedID, at: indexPath)
//        }
//    }
//}
//
//
