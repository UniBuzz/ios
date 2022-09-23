//
//  ProfileController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileViewController: UIViewController {

    //MARK: - Properties
    weak var delegate: ProfileControllerDelegate?
    
    lazy var titleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Profile"
        label.textColor = .heavenlyWhite
        return label
    }()
    
    lazy var emailText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "username"
        label.textColor = .heavenlyWhite
        return label
    }()
    
    lazy var usernameText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "username"
        label.textColor = .heavenlyWhite
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.backgroundColor = .creamyYellow
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .midnights
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        self.view.addSubview(titleText)
        self.view.addSubview(emailText)
        self.view.addSubview(usernameText)
        self.view.addSubview(logoutButton)
        
        titleText.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        emailText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleText.snp.bottom).offset(20)
        }
        
        usernameText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailText.snp.bottom).offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameText.snp.bottom).offset(20)
        }
        
        DispatchQueue.main.async { [self] in
            let uid = Auth.auth().currentUser?.uid
            Service.fetchUser(withUid: uid ?? "", completion: { data in
                usernameText.text = data.pseudoname
                emailText.text = data.email
                
            })
        }
    }
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }

}
