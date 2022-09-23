//
//  TabBarViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.eternalBlack
        self.tabBar.tintColor = UIColor.heavenlyWhite
        configureViewControllers()
        overrideUserInterfaceStyle = .dark
        presentLoginScreen()
        
    }
    
    // MARK: - Functions and Selectors
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
        let feeds = LoginViewController()
        let nav1 = navigationController(image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"),title: "Feeds", rootViewController: feeds)
        let mission = MissionViewController()
        let nav2 = navigationController(image: UIImage(systemName: "list.bullet.rectangle.portrait"),selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"),title: "Mission", rootViewController: mission)
        let conversation = ConversationViewController()
        let nav3 = navigationController(image: UIImage(systemName: "envelope"),selectedImage: UIImage(systemName: "envelope.fill"), title: "Message", rootViewController: conversation)
        let profile = ProfileViewController()
        let nav4 = navigationController(image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"),title: "Profile", rootViewController: profile)
        viewControllers = [nav1,nav2,nav3,nav4]
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginViewController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
