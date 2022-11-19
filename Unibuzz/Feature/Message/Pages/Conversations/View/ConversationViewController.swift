//
//  ConversationController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit

class ConversationViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel = ConversationViewModel()
    fileprivate let reuseIdentifier = "ConversationCell"
    let tableView = UITableView()
    let appearance = UINavigationBarAppearance()
    var totalNotifications: Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItems()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        tableView.backgroundColor = .midnights
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavigationItems(){
        let title = UILabel()
        title.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        title.text = "Chat"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textAlignment = .left
        title.textColor = .heavenlyWhite
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .midnights
        self.navigationController?.navigationBar.standardAppearance = appearance;
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.tintColor = .heavenlyWhite
        self.navigationItem.titleView = title
        self.navigationController?.navigationBar.barTintColor = .midnights
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatCollectionViewController(user: user)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.selectionStyle = .none
        cell.viewModel = ConversationCellViewModel(conversation: viewModel.conversations[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
}
