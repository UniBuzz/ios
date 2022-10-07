//
//  ChangePseudonameViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 07/10/22.
//

import UIKit

class ChangePseudonameViewController: UIViewController {

    //MARK: - Properties

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Change Pseudoname", preferredLargeTitle: false)
    }
}
