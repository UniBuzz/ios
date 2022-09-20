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
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .blue
        configureViewControllers()
        
    }
    
    // MARK: - Functions and Selectors
    func navigationController(image: UIImage?, title: String, rootViewController: UIViewController) ->
        UINavigationController{
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = image
            nav.tabBarItem.title = title
            nav.navigationBar.barTintColor = .black
            return nav
        }
    
    func configureViewControllers() {
        let feeds = FeedViewController()
        let nav1 = navigationController(image: UIImage(systemName: "house"),title: "Feeds", rootViewController: feeds)
        let mission = MissionViewController()
        let nav2 = navigationController(image: UIImage(systemName: "doc.plaintext"),title: "Mission", rootViewController: mission)
        let conversation = ConversationViewController()
        let nav3 = navigationController(image: UIImage(systemName: "envelope"), title: "Message", rootViewController: conversation)
        let profile = ProfileViewController()
        let nav4 = navigationController(image: UIImage(systemName: "person"), title: "Profile", rootViewController: profile)
        viewControllers = [nav1,nav2,nav3,nav4]
    }
}
