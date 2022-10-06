//
//  HoneyViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 06/10/22.
//

import UIKit

class HoneyViewController: UIViewController {

    //MARK: - Properties

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Drops of Honey", preferredLargeTitle: false)
    }
}
