//
//  FeedController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import RxSwift

class FeedViewController: UIViewController {
    
    //MARK: - Properties
    lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .yellow
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        return tableView
    }()
    
    private var dummyData = DummyData()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureUI()
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
}
