//
//  ConversationController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit

class ConversationController: UIViewController {
    
    //MARK: - Properties
    
    fileprivate let reuseIdentifier = "ConversationCell"
    private let tableView = UITableView()
    private var conversations = dummyConversations
    private var conversationDictionary = [String : Conversation]()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.scrollEdgeAppearance = .none
        self.navigationItem.title = "Chats"
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .white
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = self.view.frame
    }
}

//MARK: - Extensions
extension ConversationController: UITableViewDelegate {
    
}

extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    
    
}
