//
//  LoginViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 23/09/22.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the view.
    }
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .midnights
    }

}
