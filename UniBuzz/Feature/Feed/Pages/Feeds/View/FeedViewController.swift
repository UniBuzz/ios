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
        return button
    }()
    
    private var bag = DisposeBag()
    private var viewModel = FeedViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
        viewModel.feedsData.bind(to: feedTableView.rx.items(cellIdentifier: FeedTableViewCell.cellIdentifier, cellType: FeedTableViewCell.self)) {index, item, cell in
            cell.feed = item
        }.disposed(by: bag)
    }

    //MARK: - Functions
    func configureUI() {
//        self.navigationItem.titleView = UIView()
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
      
    func fetchData() {
        viewModel.fetchDummyData()
    }
}
