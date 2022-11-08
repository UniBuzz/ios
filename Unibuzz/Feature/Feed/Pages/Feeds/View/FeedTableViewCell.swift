//
//  FeedTableViewCell.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 20/09/22.
//

import UIKit
import Firebase

protocol CellDelegate: AnyObject {
    func didTapMessage(uid: String, pseudoname: String)
    func didTapUpVote(model: UpvoteModel, index: IndexPath)
    func didTapComment(feed: Buzz, index: IndexPath)
}

protocol CommentCellDelegate: CellDelegate {
    func didTapShowComments(from commentID: String, at index: IndexPath)
    func didTapHideComments(from commentID: String, at index: IndexPath)
}

protocol UpdateDataSourceDelegate: AnyObject {
    func update(newData: Buzz, index: IndexPath)
}

protocol OptionButtonPressedDelegate: AnyObject {
    func optionButtonHandler(feed: Buzz)
}

class FeedTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    weak var cellDelegate: CellDelegate?
    weak var commentCellDelegate: CommentCellDelegate?
    weak var updateDataSourceDelegate: UpdateDataSourceDelegate?
    weak var optionButtonPressedDelegate: OptionButtonPressedDelegate?
    static var cellIdentifier: String = "FeedCell"
    private let actionContainerColor:UIColor = .rgb(red: 83, green: 83, blue: 83)
    internal var userUID: String = ""
    internal var parentFeed: String = ""
    internal var isUpvoted: Bool = false
    internal var isCommentShown: Bool = false
    internal var indexPath: IndexPath?
    internal var addSeperator: Bool = false
    
    private var avatarImageView: AvatarGenerator = {
        let avatarImageView = AvatarGenerator(pseudoname: "", background: 0)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        avatarImageView.layer.cornerRadius = 22/2
        return avatarImageView
    }()
    
    internal var cellViewModel: FeedCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            userName.text = cellViewModel.feed.userName
            content.text = cellViewModel.feed.content
            commentCount.setTitle("  \(cellViewModel.feed.commentCount)", for: .normal)
            upVoteCount.setTitle(" \(cellViewModel.feed.upvoteCount)", for: .normal)
            isUpvoted = cellViewModel.feed.isUpvoted
            indexPath = cellViewModel.indexPath
            isCommentShown = cellViewModel.feed.isChildCommentShown
            avatarImageView.pseudoname = cellViewModel.feed.userName
            avatarImageView.randomInt = cellViewModel.feed.randomIntBackground
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
    
    lazy var mainStack: UIStackView = {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
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
        label.textAlignment = .left
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
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var upVoteCount: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
        button.addTarget(self, action: #selector(upVotePressed), for: .touchUpInside)
        button.setTitle("10", for: .normal)
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
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.tintColor = .heavenlyWhite
        button.addTarget(self, action: #selector(handleOption), for: .touchUpInside)
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
    
    internal var beeImageView: UIImageView?
    
    private let hstack1 = UIStackView()
    private let hstack2 = UIStackView()
    private let miniStack2 = UIStackView()
    private var containerWithSpacer = UIStackView()
    private let spacer1 = UIView.spacer(size: 36, for: .horizontal)
    private let spacer2 = UIView.spacer(size: 36, for: .horizontal)
    private let spacer3 = UIView.spacer(size: 16, for: .vertical)
    private let spacer4 = UIView.spacer(size: 16, for: .vertical)
    private let spacer5 = UIView.spacer(size: 20, for: .horizontal)
    private let spacer6 = UIView.spacer(size: 5, for: .horizontal)
    private let spacer7 = UIView.spacer(size: 20, for: .horizontal)
    
    private lazy var seperator: UIView = {
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    private var seperatorConstraint = NSLayoutConstraint()
    
    private let gradient = CAGradientLayer()
    private let shape = CAShapeLayer()
    private let gradientBorder1 = UIColor(red: 255/255, green: 243/255, blue: 143/255, alpha: 0.3)
    private let gradientBorder2 = UIColor(red: 255/255, green: 243/255, blue: 143/255, alpha: 0.05)

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        seperatorConstraint = NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3)
        seperatorConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beeImageView?.removeFromSuperview()
    }
  
    //MARK: - Selectors
    @objc func upVotePressed() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let indexPath = indexPath else { return }
        guard let feed = cellViewModel?.feed else { return }
        
        if isUpvoted {
            cellViewModel?.feed.upvoteCount -= 1
            cellViewModel?.feed.isUpvoted = false
            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
            upVoteCount.tintColor = .heavenlyWhite
        } else {
            cellViewModel?.feed.upvoteCount += 1
            cellViewModel?.feed.isUpvoted = true
            upVoteCount.setTitleColor(.creamyYellow, for: .normal)
            upVoteCount.tintColor = .creamyYellow
        }
        if feed.buzzType == .feed {
            upVoteCountContainer.backgroundColor = actionContainerColor
        } else {
            upVoteCountContainer.backgroundColor = .clear
        }
        
        let upvoteModel = UpvoteModel(buzzType: feed.buzzType, repliedFrom: feed.repliedFrom, feedToVote: feed.feedID, currenUserID: currentUserID, posterID: feed.uid)
        
        cellDelegate?.didTapUpVote(model: upvoteModel, index: indexPath)
        commentCellDelegate?.didTapUpVote(model: upvoteModel, index: indexPath)
        
        // need to make it safer without force unwrap!!!
        updateDataSourceDelegate?.update(newData: cellViewModel!.feed, index: indexPath)
    }
    
    @objc func commentCountPressed() {
        guard let feed = cellViewModel?.feed else { return }
//        print("Go To Comment Page with content of \(feed.content)")
        guard let indexPath = indexPath else { return }
        cellDelegate?.didTapComment(feed: feed, index: indexPath)
        commentCellDelegate?.didTapComment(feed: feed, index: indexPath)
    }
    
    @objc func sendMessagePressed() {
        guard let feed = cellViewModel?.feed else { return }
//        print("send message to this id: \(feed.uid)")
        cellDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
        commentCellDelegate?.didTapMessage(uid: feed.uid, pseudoname: feed.userName)
    }
    
    //MARK: - Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .midnights
        
        if let beeImageView = beeImageView {
            self.contentView.addSubview(beeImageView)
            beeImageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview().offset(-40)
                make.top.equalToSuperview().offset(-250 / 2)
                make.height.equalTo(250)
            }
        }
        
        self.contentView.addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }

        containerWithSpacer = UIStackView(arrangedSubviews: [
            spacer1,
            container,
            spacer2
        ])
        
        containerWithSpacer.axis = .horizontal
        containerWithSpacer.distribution = .fill
        
        containerStack.addArrangedSubview(spacer3)
        containerStack.addArrangedSubview(containerWithSpacer)
        containerStack.addArrangedSubview(spacer4)
        container.addSubview(mainStack)

        mainStack.snp.makeConstraints { make in
            make.top.equalTo(self.container.snp.top).offset(10)
            make.left.equalTo(self.container.snp.left).offset(20)
            make.right.equalTo(self.container.snp.right).offset(-20)
            make.bottom.equalTo(self.container.snp.bottom).offset(-15)
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
        hstack1.addArrangedSubview(avatarImageView)
        hstack1.addArrangedSubview(spacer6)
        hstack1.addArrangedSubview(userName)
        hstack1.addArrangedSubview(optionButton)
        hstack1.distribution = .fillProportionally
        
        miniStack2.axis = .horizontal
        miniStack2.addArrangedSubview(upVoteCountContainer)
        miniStack2.addArrangedSubview(commentCountContainer)
        miniStack2.spacing = 10
        
        hstack2.axis = .horizontal
        hstack2.addArrangedSubview(miniStack2)
        hstack2.addArrangedSubview(spacer7)
        hstack2.addArrangedSubview(sendMessageButtonContainer)
        hstack2.distribution = .equalSpacing
        
        mainStack.addArrangedSubview(hstack1)
        mainStack.addArrangedSubview(content)
        mainStack.addArrangedSubview(hstack2)
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = .init(width: 0, height: 4)
        container.layer.shadowRadius = 10
        
        checkShowOrHideComments()
        checkUpvoteButton()
        checkBuzzType()
    }
    
    func checkUpvoteButton() {
        guard let feed = cellViewModel?.feed else { return }
        
        if userUID == feed.uid {
            upVoteCount.isEnabled = false
            sendMessageButton.isHidden = true
            sendMessageButtonContainer.isHidden = true
        } else {
            upVoteCount.isEnabled = true
            sendMessageButton.isHidden = false
            sendMessageButtonContainer.isHidden = false
        }

        if feed.isUpvoted {
            upVoteCount.setTitleColor(.creamyYellow, for: .normal)
            upVoteCount.titleLabel?.textColor = .creamyYellow
            upVoteCount.tintColor = .creamyYellow
        } else {
            upVoteCount.setTitleColor(.heavenlyWhite, for: .normal)
            upVoteCount.tintColor = .heavenlyWhite
        }
        upVoteCountContainer.backgroundColor = actionContainerColor

    }
    
    
    func checkShowOrHideComments() {
        guard let feed = cellViewModel?.feed else { return }
        
        if feed.isChildCommentShown {
            showOrHideCommentsButton.setTitle("See less", for: .normal)
        } else {
            showOrHideCommentsButton.setTitle("See more", for: .normal)
        }
    }
    
    func checkBuzzType() {
        guard let feed = cellViewModel?.feed else { return }
        seperator.backgroundColor = .heavenlyWhite
        
        if addSeperator {
            containerStack.addArrangedSubview(seperator)
        } else {
            containerStack.removeArrangedSubview(seperator)
            seperator.removeFromSuperview()
        }
        
        switch feed.buzzType {
        case .feed:
            container.backgroundColor = .stoneGrey
            container.layer.borderColor = UIColor.creamyYellow.withAlphaComponent(0.4).cgColor
            container.layer.borderWidth = 2
            sendMessageButtonContainer.backgroundColor = actionContainerColor
            commentCountContainer.backgroundColor = actionContainerColor
            commentCountContainer.isHidden = false
            mainStack.removeArrangedSubview(showOrHideCommentsButton)
            showOrHideCommentsButton.removeFromSuperview()
            seperatorConstraint.constant = 3
        case .comment:
            container.backgroundColor = .clear
            container.layer.borderWidth = 0
            sendMessageButtonContainer.backgroundColor = .clear
            commentCountContainer.backgroundColor = .clear
            upVoteCountContainer.backgroundColor = .clear
            commentCountContainer.isHidden = false
            seperatorConstraint.constant = 0.5
            if cellViewModel?.feed.commentCount != 0 {
                mainStack.addArrangedSubview(showOrHideCommentsButton)
            } else {
                mainStack.removeArrangedSubview(showOrHideCommentsButton)
                showOrHideCommentsButton.removeFromSuperview()
            }
        case .childComment:
            container.backgroundColor = .clear
            container.layer.borderWidth = 0
            sendMessageButtonContainer.backgroundColor = .clear
            commentCountContainer.backgroundColor = .clear
            upVoteCountContainer.backgroundColor = .clear
            commentCountContainer.isHidden = true
            mainStack.removeArrangedSubview(showOrHideCommentsButton)
            showOrHideCommentsButton.removeFromSuperview()
            containerWithSpacer.insertArrangedSubview(spacer5, at: 0)
            seperatorConstraint.constant = 0.5
        }
    }
    
    func addShowMoreOrLessButton() {
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
            commentCellDelegate?.didTapShowComments(from: cellViewModel.feed.feedID, at: indexPath)
        } else {
            showOrHideCommentsButton.setTitle("See more", for: .normal)
            commentCellDelegate?.didTapHideComments(from: cellViewModel.feed.feedID, at: indexPath)
        }
    }
    
    @objc func handleOption() {
        guard let feed = cellViewModel?.feed else { return }
        optionButtonPressedDelegate?.optionButtonHandler(feed: feed)
    }
}

extension UIView {

    static func spacer(size: CGFloat = 10, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        
        if layout == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        return spacer
    }
}

