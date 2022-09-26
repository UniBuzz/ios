//
//  FeedController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController {
    
    //MARK: - Variables
    private var bag = DisposeBag()
    private var viewModel = FeedViewModel()
    
    //MARK: - Properties
    lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .midnights
        return tableView
    }()
    
    lazy var addFeedButtonContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 56/2
        view.backgroundColor = .creamyYellow
        return view
    }()
    
    lazy var addFeedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)), for: .normal)
        button.tintColor = .eternalBlack
        button.addTarget(self, action: #selector(addFeedButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItems()
        fetchData()
        viewModel.feedsData.bind(to: feedTableView.rx.items(cellIdentifier: FeedTableViewCell.cellIdentifier, cellType: FeedTableViewCell.self)) {index, item, cell in
            cell.feed = item
            cell.feedDelegate = self
        }.disposed(by: bag)
        feedTableView.rx.modelSelected(FeedModel.self).subscribe { feed in
            print(feed)
        }.disposed(by: bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Selector Functions
    @objc func addFeedButtonPressed() {
        let createFeedVC = PostFeedViewController()
        self.navigationController?.pushViewController(createFeedVC, animated: true)
    }
    
    @objc func searchButtonPressed() {
        
    }
    
    @objc func notificationButtonPressed() {
        
    }
    
    //MARK: - Functions
    func fetchData() {
        viewModel.fetchFeed()
    }
    
    func configureUI() {
        view.backgroundColor = .midnights
        self.view.addSubview(feedTableView)
        self.view.addSubview(addFeedButtonContainer)
        addFeedButtonContainer.addSubview(addFeedButton)

        feedTableView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        addFeedButtonContainer.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        addFeedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func configureNavigationItems(){
                
        let title = UILabel()
        title.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        title.text = "Feeds"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textAlignment = .left
        title.textColor = .heavenlyWhite
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonPressed))
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationButtonPressed))
        searchButton.tintColor = .heavenlyWhite
        notificationButton.tintColor = .heavenlyWhite
        navigationItem.rightBarButtonItems = [notificationButton, searchButton]
        self.navigationController?.navigationBar.backgroundColor = .midnights
        self.navigationItem.titleView = title
        self.navigationController?.navigationBar.barTintColor = .midnights
    }
}

extension FeedViewController: FeedCellDelegate {
    func didTapMessage(uid: String, pseudoname: String) {
        print(pseudoname)
        let controller = ChatCollectionViewController(user: User(dictionary: ["uid": uid, "pseudoname": pseudoname]))
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
