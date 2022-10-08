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
    
    var feed: Buzz?
    var viewModel = CommentsViewModel()
    var bag = DisposeBag()
    
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
        infoLabelAboveTextField.text = "Replying to MabaHoki123"
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
    
    override func viewDidLoad() {
        guard let feed = feed else { return }
        super.viewDidLoad()
        view.backgroundColor = .midnights
        configureUI()
        viewModel.loadComments(from: feed)
        bind()
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
        print("posted")
    }
    
    func bind() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        viewModel.comments.bind(to: tableView.rx.items(cellIdentifier: FeedTableViewCell.cellIdentifier, cellType: FeedTableViewCell.self)) { index, item, cell in
            if index == 0 {
                cell.seperatorForFeedsAndComments = UIView(frame: .zero)
            }
            cell.userUID = uid
            cell.feed = item
        }.disposed(by: bag)
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


