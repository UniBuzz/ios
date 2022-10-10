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
    var viewmodel = ConversationViewModel()
    fileprivate let reuseIdentifier = "ConversationCell"
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchConversations()
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
        controller.conversationViewmodel = viewmodel
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func fetchConversations() {
        Service.fetchConversations { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)

    }
    
}
