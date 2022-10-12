//
//  TabBarViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    // MARK: - properties
    let conversationVC = ConversationViewController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConversations()
    }
    
    // MARK: - Functions and Selectors
    func configureUI() {
        self.tabBar.backgroundColor = UIColor.eternalBlack
        self.tabBar.tintColor = UIColor.heavenlyWhite
        configureViewControllers()
        overrideUserInterfaceStyle = .dark
        self.tabBar.selectedImageTintColor = .creamyYellow
    }
    
    func navigationController(image: UIImage?, selectedImage: UIImage?, title: String, rootViewController: UIViewController ,badge: String?) ->
        UINavigationController{
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = image
            nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.creamyYellow], for: .selected)
            nav.tabBarItem.selectedImage = selectedImage
            nav.tabBarItem.title = title
            nav.tabBarItem.badgeValue = badge
            nav.tabBarController?.tabBar.isTranslucent = false
            nav.navigationBar.backgroundColor = .eternalBlack
            return nav
        }
    
    func configureViewControllers() {
        let feeds = FeedViewController()
        let nav1 = navigationController(image: UIImage(systemName: "circle.hexagongrid.fill"), selectedImage: UIImage(systemName: "circle.hexagongrid.fill")?.withTintColor(.creamyYellow),title: "Hive", rootViewController: feeds, badge: nil)
        let nav3 = navigationController(image: UIImage(systemName: "envelope"),selectedImage: UIImage(systemName: "envelope.fill"), title: "Message", rootViewController: conversationVC,badge: nil)
        let profile = ProfileViewController()
        profile.delegate = self
        let nav4 = navigationController(image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"),title: "Profile", rootViewController: profile, badge: nil)
        viewControllers = [nav1,nav3,nav4]
    }
    
    func fetchConversations() {
        Service.fetchConversations { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationVC.viewmodel.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversationVC.viewmodel.conversations = Array(self.conversationVC.viewmodel.conversationsDictionary.values)
            self.conversationVC.totalNotifications = 0
            for conversation in self.conversationVC.viewmodel.conversations {
                self.conversationVC.totalNotifications += conversation.unreadMessages
            }
            self.conversationVC.navigationController?.tabBarItem.badgeValue = self.conversationVC.viewmodel.isThereANotification(self.conversationVC.totalNotifications)
            self.conversationVC.tableView.reloadData()
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginViewController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    func authenticateUser() {
        do {
            if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isEmailVerified == false {
                try Auth.auth().signOut()
            }
        } catch {
            print("Error happened here")
        }
        
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        }else {
            print("DEBUG: the current user id is \(Auth.auth().currentUser?.uid ?? "")")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error signin out..")
        }
        authenticateUser()
    }

}

extension TabBarViewController: AuthenticationDelegate {
    func authenticationComplete() {
        configureUI()
        dismiss(animated: true, completion: nil)
    }
}

extension TabBarViewController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
    
    func handleDeleteAccount() {
        logout()
    }
}
