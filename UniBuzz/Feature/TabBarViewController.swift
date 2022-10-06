//
//  TabBarViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        logout()
        configureUI()
        authenticateUser()
    }
    
    // MARK: - Functions and Selectors
    func configureUI() {
        self.tabBar.backgroundColor = UIColor.eternalBlack
        self.tabBar.tintColor = UIColor.heavenlyWhite
        configureViewControllers()
        overrideUserInterfaceStyle = .dark
    }
    
    func navigationController(image: UIImage?, selectedImage: UIImage?, title: String, rootViewController: UIViewController) ->
        UINavigationController{
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = image
            nav.tabBarItem.selectedImage = selectedImage
            nav.tabBarItem.title = title
            nav.tabBarController?.tabBar.isTranslucent = false
            nav.navigationBar.barTintColor = .heavenlyWhite
            nav.navigationBar.backgroundColor = .eternalBlack
            return nav
        }
    
    func configureViewControllers() {
        let feeds = FeedViewController()
        let nav1 = navigationController(image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"),title: "Feeds", rootViewController: feeds)
        let mission = MissionViewController()
        let nav2 = navigationController(image: UIImage(systemName: "list.bullet.rectangle.portrait"),selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"),title: "Mission", rootViewController: mission)
        let conversation = ConversationViewController()
        let nav3 = navigationController(image: UIImage(systemName: "envelope"),selectedImage: UIImage(systemName: "envelope.fill"), title: "Message", rootViewController: conversation)
        let profile = ProfileViewController()
        profile.delegate = self
        let nav4 = navigationController(image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"),title: "Profile", rootViewController: profile)
        viewControllers = [nav1,nav3,nav4]
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
//        fetchConversations()
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
}

extension TabBarViewController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}
