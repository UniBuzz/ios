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
import Mixpanel

class CommentsViewController: UIViewController {
    
    private var commentsViewModel: CommentsViewModel
    internal weak var updateDataSourceDelegate: UpdateDataSourceDelegate?
    internal var parentIndexPath: IndexPath
    
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
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        return tap
    }()
    
    var bottomConstraint = NSLayoutConstraint()
    var originalConstant: CGFloat = 0
    
    init(commentsViewModel: CommentsViewModel, parentIndexPath: IndexPath) {
        self.commentsViewModel = commentsViewModel
        self.parentIndexPath = parentIndexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .midnights
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        commentsViewModel.delegate = self
        Task.init {
            commentsViewModel.loadComments()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        updateDataSourceDelegate?.update(newData: commentsViewModel.comments[0], index: parentIndexPath)
    }
        
    @objc func postComment() {
        guard let commentText = commentTextField.text else { return }
        if commentText != "" {
            commentTextField.resignFirstResponder()
            Task.init {
                switch commentsViewModel.feedBuzzTapped.buzzType {
                case .feed:
                    commentsViewModel.replyComments(from: .feed, commentContent: commentText, feedID: commentsViewModel.feedBuzzTapped.feedID)
                case .comment:
                    commentsViewModel.replyComments(from: .anotherComment(anotherCommentID: commentsViewModel.feedBuzzTapped.feedID), commentContent: commentText, feedID: commentsViewModel.feedBuzzTapped.repliedFrom)
                case .childComment:
                    return
                }
            }
            commentTextField.text = ""
            var properties = [
                "from": "\(Auth.auth().currentUser?.uid ?? "")",
                "buzz_content": "\(commentText)"
            ]
            commentsViewModel.trackEvent(event: "comment_post", properties: properties)
        }
    }
    
    @objc func textFieldDidChange() {
        guard let commentText = commentTextField.text else { return }
        if commentText.isEmpty {
            sendButtonContainer.backgroundColor = .cloudSky
            sendButton.isEnabled = false
        } else {
            sendButtonContainer.backgroundColor = .creamyYellow
            sendButton.isEnabled = true
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
        tableView.keyboardDismissMode = .onDrag
    
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
            make.height.equalTo(view.bounds.height * 0.14)
        }
        
        bottomConstraint = NSLayoutConstraint(item: footer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: originalConstant)
        bottomConstraint.isActive = true

        infoLabelAboveTextField.snp.makeConstraints { make in
            make.top.equalTo(footer).offset(4)
            make.left.equalTo(footer).offset(20)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.bottom.equalTo(footer.snp.bottom).offset(-20)
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

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource, CommentCellDelegate, CommentViewModelDelegate {
    
    func scrollTableView(to index: IndexPath) {
        tableView.scrollToRow(at: index, at: .bottom, animated: true)
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
        cell.commentCellDelegate = self
        cell.optionButtonPressedDelegate = self
        cell.indexPath = indexPath
        cell.parentFeed = commentsViewModel.feedBuzzTapped.feedID
        cell.userUID = uid
        cell.addSeperator = true
        cell.cellViewModel = self.commentsViewModel.getDataForFeedCell(feed: item, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buzz = commentsViewModel.comments[indexPath.row]
        self.infoLabelAboveTextField.text = "Replying to \(buzz.userName)"
        self.commentTextField.becomeFirstResponder()
        commentsViewModel.feedBuzzTapped = buzz
        commentsViewModel.indexTapped = indexPath.row
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func didTapMessage(uid: String, pseudoname: String) {
        let controller = ChatCollectionViewController(user: User(dictionary: ["uid": uid, "pseudoname": pseudoname]))
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapUpVote(model: UpvoteModel, index: IndexPath) {
        Task.init {
            commentsViewModel.upvoteContent(model: model, index: index)
        }
    }
    
    func didTapComment(feed: Buzz, index: IndexPath) {
        self.infoLabelAboveTextField.text = "Replying to \(feed.userName)"
        self.commentTextField.becomeFirstResponder()
        if !feed.isChildCommentShown {
            commentsViewModel.showChildComment(from: feed.feedID, at: index)
        }
        commentsViewModel.indexTapped = index.row
        commentsViewModel.feedBuzzTapped = feed
    }
    
    func didTapShowComments(from commentID: String, at index: IndexPath) {
        commentsViewModel.showChildComment(from: commentID, at: index)
    }
    func didTapHideComments(from commentID: String, at index: IndexPath) {
        commentsViewModel.hideChildComment(from: commentID, at: index)
    }
}

extension CommentsViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = -keyboardSize.height - 5
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = self.originalConstant
            self.view.layoutIfNeeded()
        }
    }
}

extension CommentsViewController: OptionButtonPressedDelegate {
    func optionButtonHandler(feed: Buzz) {
        let alert = UIAlertController(title: feed.userName, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report this post", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.reportAction(feed: feed, reportFor: .buzz)
            }
        }))
        alert.addAction(UIAlertAction(title: "Report Account", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.reportAction(feed: feed, reportFor: .account)
            }
        }))
        alert.addAction(UIAlertAction(title: "Block", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                self.commentsViewModel.blockAccount(targetAccountUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }
    
    func reportAction(feed: Buzz, reportFor: ReportFor) {
        let alert = UIAlertController(title: nil, message: "Mengapa ingin melapor?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Spam", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Spam", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Spam", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Nudity atau aktivitas seksual", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Nudity atau aktivitas seksual", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Nudity atau aktivitas seksual", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Informasi yang salah", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Informasi yang salah", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Informasi yang salah", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Bullying atau pelecehan", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Bullying atau pelecehan", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Bullying atau pelecehan", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Ujaran kebencian", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Ujaran kebencian", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Ujaran kebencian", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Doxing", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                switch reportFor {
                case .account:
                    self.commentsViewModel.reportUser(reason: "Doxing", feed: feed)
                case .buzz:
                    self.commentsViewModel.reportHive(reason: "Doxing", feed: feed)
                }
                self.afterReportAction(targetUserUid: feed.uid)
            }
        }))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
    func afterReportAction(targetUserUid: String) {
        let alert = UIAlertController(title: nil, message: "Terima kasih, laporan kamu sudah masuk. Ini langkah berikutnya yang bisa kamu lakukan", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Blokir Akun", style: .destructive, handler: { _ in
                self.dismiss(animated: true) {
                    self.commentsViewModel.blockAccount(targetAccountUid: targetUserUid)
                    
                }
        }))
        alert.addAction(UIAlertAction(title: "Selesai", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
}

