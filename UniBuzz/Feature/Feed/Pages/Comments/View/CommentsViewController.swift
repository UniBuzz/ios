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
        sendButton.setImage(UIImage(named: "paperplane"), for: .normal)
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
        
    func bind() {
        viewModel.comments.bind(to: tableView.rx.items(cellIdentifier: FeedTableViewCell.cellIdentifier, cellType: FeedTableViewCell.self)) { index, item, cell in
            cell.feed = item
            switch item.forPage {
            case .openCommentPage:
                print("feeds layout")
            case .loadComment:
                print("feeds as a comment")
            }
        }.disposed(by: bag)
    }
    
    func configureUI() {
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
            make.left.equalTo(footer).offset(10)
            make.top.equalTo(infoLabelAboveTextField.snp.bottom)
            make.width.equalTo(view.bounds.width * 0.75 )
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
            make.left.equalTo(textFieldContainer.snp.right).offset(5)
            make.right.equalTo(footer).offset(-10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        print(textFieldContainer.bounds.height)
        print(textFieldContainer.frame.height)

        sendButtonContainer.layer.cornerRadius = sendButtonContainer.bounds.height / 2
        textFieldContainer.layer.cornerRadius = 20
        
    }

}
