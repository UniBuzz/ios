//
//  DeleteUserViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//


import UIKit
import SnapKit

class DeleteUserViewController: UIViewController {

    //MARK: - Properties
    

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Delete Account", preferredLargeTitle: false)
        }
}

