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
    var totalNotifications: Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated:Bool) {
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Message", preferredLargeTitle: true)
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
    
    func showChatController(forUser user: User) {
        let controller = ChatCollectionViewController(user: user)
        controller.conversationViewmodel = viewModel
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
