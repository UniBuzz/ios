//
//  ConversationController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class ConversationViewController: UIViewController {
    
    //MARK: - Properties
    fileprivate let reuseIdentifier = "ConversationCell"
    private let tableView = UITableView()
    private var viewModel = ConversationViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindTableView()
    }
    
    //MARK: - Funcations
    func configureUI() {
        view.backgroundColor = .midnights
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .midnights
        self.navigationController?.navigationBar.scrollEdgeAppearance = .none
        self.navigationItem.title = "Direct Messages"
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        tableView.backgroundColor = .midnights
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    func showChatController(forUser user: String) {
        let controller = ChatCollectionViewController(user: user)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Binding
extension ConversationViewController {
    func bindTableView() {
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier:reuseIdentifier, cellType: ConversationCell.self)) { (row,item,cell) in
            cell.conversation = item
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Conversation.self).subscribe{ item in
            let user = item.username
            self.showChatController(forUser: user)
        }.disposed(by: disposeBag)
    }
}


