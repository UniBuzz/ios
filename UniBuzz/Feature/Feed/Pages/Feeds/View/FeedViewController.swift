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
        return tableView
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
        self.view.addSubview(feedTableView)
        feedTableView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
      
    func fetchData() {
        viewModel.fetchDummyData()
    }
}
