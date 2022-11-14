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
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let blur = UIVisualEffectView(effect: effect)
        return blur
    }()
    private lazy var dropHoneyImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "dropofhoney")
        return image
    }()
    
    private lazy var honeyView: UIView = {
        let hv = DropOfHoneyView()
        hv.startButton.addTarget(self, action: #selector(startHive), for: .touchUpInside)
        return hv
    }()
    
    let comebackUser = UserDefaults.standard.bool(forKey: "comebackUser")
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if !comebackUser {
            presentDropHoney()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.presentGetHoney()
            }
        }
        fetchConversations()
        
        
    }
    
    // MARK: - Functions and Selectors
    func configureUI() {
        self.tabBar.backgroundColor = UIColor.eternalBlack
        self.tabBar.tintColor = UIColor.heavenlyWhite
        configureViewControllers()
        overrideUserInterfaceStyle = .dark
        self.tabBar.tintColor = .creamyYellow
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
        ConversationService.shared.fetchConversations { conversations in
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationVC.viewModel.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversationVC.viewModel.conversations = Array(self.conversationVC.viewModel.conversationsDictionary.values)
            self.conversationVC.viewModel.conversations = self.conversationVC.viewModel.conversations.sorted(by: { $0.message.timestamp.dateValue() > $1.message.timestamp.dateValue() })
            self.conversationVC.totalNotifications = 0
            for conversation in self.conversationVC.viewModel.conversations {
                self.conversationVC.totalNotifications += conversation.unreadMessages
            }
            self.conversationVC.navigationController?.tabBarItem.badgeValue = self.conversationVC.viewModel.isThereANotification(self.conversationVC.totalNotifications)
            self.conversationVC.tableView.reloadData()
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func presentDropHoney() {
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        dropHoneyImage.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        dropHoneyImage.center = view.center
        view.addSubview(dropHoneyImage)
        dropHoneyImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        dropHoneyImage.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.dropHoneyImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.dropHoneyImage.alpha = 1
        }
        
    }
    
    func presentGetHoney() {
        UIView.animate(withDuration: 1) {
            self.dropHoneyImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.dropHoneyImage.alpha = 0
        } completion: { _ in
            self.dropHoneyImage.removeFromSuperview()
        }
        
        honeyView.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        honeyView.center = view.center
        view.addSubview(honeyView)
        honeyView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        honeyView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.honeyView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.honeyView.alpha = 1
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
            Firestore.firestore().clearPersistence()
        } catch {
            print("DEBUG: Error signin out..")
        }
        authenticateUser()
    }
    
    //MARK: - Selector
    
    @objc func startHive() {
        UserDefaults.standard.setValue(true, forKey: "comebackUser")
        UIView.animate(withDuration: 1) {
            self.honeyView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.honeyView.alpha = 0
        } completion: { _ in
            self.dropHoneyImage.removeFromSuperview()
            self.blurView.removeFromSuperview()
        }
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
