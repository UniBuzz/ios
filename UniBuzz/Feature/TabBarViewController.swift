//
//  TabBarViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .blue
        configureViewControllers()
        
    }
    
    func navigationController(image: UIImage?, title: String, rootViewController: UIViewController) ->
        UINavigationController{
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = image
            nav.tabBarItem.title = title
            nav.navigationBar.barTintColor = .black
            return nav
        }
    
    func configureViewControllers() {
        let feeds = ConversationController()
        let nav1 = navigationController(image: UIImage(systemName: "house"),title: "Feeds", rootViewController: feeds)
        let search = ConversationController()
        let nav2 = navigationController(image: UIImage(systemName: "magnifyingglass"),title: "Search", rootViewController: search)
        let mission = ConversationController()
        let nav3 = navigationController(image: UIImage(systemName: "doc.plaintext"), title: "Mission", rootViewController: mission)
        let conversation = ConversationController()
        let nav4 = navigationController(image: UIImage(systemName: "envelope"), title: "Chat", rootViewController: conversation)
        viewControllers = [nav1,nav2,nav3,nav4]
    }
}
