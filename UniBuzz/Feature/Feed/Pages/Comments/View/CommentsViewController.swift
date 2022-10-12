//
//  CommentsViewController.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 05/10/22.
//

import UIKit
import Firebase
import SnapKit
import RxSwift
import RxDataSources

class CommentsViewController: UIViewController {
    
    var commentsViewModel: CommentsViewModel
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        tableView.backgroundColor = .midnights
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.placeholder = "Aa"
        return commentTextField
    }()
    
    lazy var infoLabelAboveTextField: UILabel = {
        let infoLabelAboveTextField = UILabel()
        infoLabelAboveTextField.text = "Replying to \(commentsViewModel.feedBuzzTapped.userName)"
        infoLabelAboveTextField.textColor = .cloudSky
        infoLabelAboveTextField.font = .systemFont(ofSize: 13)
        return infoLabelAboveTextField
    }()
    
    lazy var textFieldContainer: UIView = {
        let textFieldContainer = UIView()
        textFieldContainer.backgroundColor = .midnights
        return textFieldContainer
    }()
    
    lazy var sendButtonContainer: UIView = {
        let sendButtonContainer = UIView()
        sendButtonContainer.backgroundColor = .cloudSky
        return sendButtonContainer
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendButton.tintColor = .eternalBlack
        sendButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        return sendButton
    }()
    
    lazy var footer: UIView = {
        let footer = UIView()
        footer.backgroundColor = .eternalBlack
        return footer
    }()
    
    init(commentsViewModel: CommentsViewModel) {
        self.commentsViewModel = commentsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .midnights
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        commentsViewModel.delegate = self
        commentsViewModel.loadComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
        
    @objc func postComment() {
        guard let commentText = commentTextField.text else { return }
        if commentText != "" {
            switch commentsViewModel.feedBuzzTapped.buzzType {
            case .feed:
                commentsViewModel.replyComments(from: .feed, commentContent: commentText, feedID: commentsViewModel.feedBuzzTapped.feedID)
            case .comment:
                commentsViewModel.replyComments(from: .anotherComment(anotherCommentID: commentsViewModel.feedBuzzTapped.feedID), commentContent: commentText, feedID: commentsViewModel.feedBuzzTapped.repliedFrom)
            case .childComment:
                return
            }
            commentTextField.text = ""
        }
    }
    
    func configureUI() {
        let textFieldAndSendButtonHeight: CGFloat = 35
        
        view.addSubview(tableView)
        view.addSubview(footer)
        footer.addSubview(textFieldContainer)
        footer.addSubview(infoLabelAboveTextField)
        footer.addSubview(sendButtonContainer)
        sendButtonContainer.addSubview(sendButton)
        textFieldContainer.addSubview(commentTextField)
        
        self.navigationItem.title = "Comments"
        self.navigationController?.navigationBar.tintColor = .heavenlyWhite
        self.navigationController?.navigationBar.topItem?.title = ""
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(footer.snp.top)
        }
        
        footer.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(view.bounds.height * 0.14)
        }
        
        infoLabelAboveTextField.snp.makeConstraints { make in
            make.top.equalTo(footer).offset(4)
            make.left.equalTo(footer).offset(20)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(footer).offset(12)
            make.top.equalTo(infoLabelAboveTextField.snp.bottom)
            make.right.equalTo(sendButtonContainer.snp.left).offset(-16)
            make.height.equalTo(textFieldAndSendButtonHeight)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        sendButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer)
            make.bottom.equalTo(textFieldContainer)
            make.right.equalTo(footer).offset(-16)
            make.width.equalTo(textFieldAndSendButtonHeight)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(sendButtonContainer)
            make.left.equalTo(sendButtonContainer)
            make.right.equalTo(sendButtonContainer)
            make.bottom.equalTo(sendButtonContainer)
        }
        
        sendButtonContainer.layer.cornerRadius = textFieldAndSendButtonHeight / 2
        textFieldContainer.layer.cornerRadius = 20
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource, CommentCellDelegate, ViewModelDelegate {
    
    func stopRefresh() {
        print("")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsViewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let uid = Auth.auth().currentUser?.uid else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifier, for: indexPath) as! FeedTableViewCell
        
        let seperator = UIView(frame: .zero )
        seperator.backgroundColor = .heavenlyWhite
        if indexPath.row != 0 {
            seperator.layer.opacity = 0.2
        }
                        
        let item = commentsViewModel.comments[indexPath.row]
        cell.commentDelegate = self
        cell.indexPath = indexPath
        cell.parentFeed = commentsViewModel.feedBuzzTapped.feedID
        cell.seperatorForFeedsAndComments = seperator
        cell.userUID = uid
        cell.cellViewModel = self.commentsViewModel.getDataForFeedCell(feed: item, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buzz = commentsViewModel.comments[indexPath.row]
        self.infoLabelAboveTextField.text = "Replying to \(buzz.userName)"
        self.commentTextField.becomeFirstResponder()
        commentsViewModel.feedBuzzTapped = buzz
        print("replying to: \(commentsViewModel.feedBuzzTapped.content)")
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func didTapMessage(uid: String, pseudoname: String) {
        let controller = ChatCollectionViewController(user: User(dictionary: ["uid": uid, "pseudoname": pseudoname]))
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapUpVote(model: UpvoteModel) {
        print("upvote tapped from comment page")
    }
    
    func didTapComment(feed: Buzz) {
        self.infoLabelAboveTextField.text = "Replying to \(feed.userName)"
        self.commentTextField.becomeFirstResponder()
        print("comment tapped from \(feed.content)")
        commentsViewModel.feedBuzzTapped = feed
    }
    
    func didTapShowComments(from commentID: String, at index: IndexPath) {
        commentsViewModel.showChildComment(from: commentID, at: index)
    }
    
    func didTapHideComments(from commentID: String, at index: IndexPath) {
        commentsViewModel.hideChildComment(from: commentID, at: index)
    }

    
}


