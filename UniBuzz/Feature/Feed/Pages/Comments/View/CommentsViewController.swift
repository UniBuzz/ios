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

    var feedID: String? = ""
    var viewModel = CommentsViewModel()
    var bag = DisposeBag()
    
    lazy var feedContent: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .midnights
        view.addSubview(feedContent)
        view.addSubview(tableView)
    }
    
    func configureUI() {
        feedContent.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(feedContent.snp.bottom)
            make.left.equalTo(feedContent)
            make.right.equalTo(feedContent)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
