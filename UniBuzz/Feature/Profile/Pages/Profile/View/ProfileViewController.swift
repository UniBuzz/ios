//
//  ProfileController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase
import SnapKit

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileViewController: UIViewController {

    //MARK: - Properties
    weak var delegate: ProfileControllerDelegate?
    
    lazy var usernameText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Pseudoname"
        label.textColor = .creamyYellow
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 80 / 2
        return iv
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
        configureNavigationItems()
    }
    
    //MARK: - Functions
    func configureUI() {
        self.view.addSubview(profileImageView)
        self.view.addSubview(usernameText)
        self.view.addSubview(logoutButton)
        self.navigationController?.navigationBar.tintColor = .midnights
        self.navigationController?.navigationBar.barTintColor = .midnights
        self.navigationController?.navigationBar.backgroundColor = .midnights
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalTo(self.view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30    )
        }
        
        usernameText.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameText.snp.bottom).offset(20)
        }
        
        DispatchQueue.main.async { [self] in
            let uid = Auth.auth().currentUser?.uid
            Service.fetchUser(withUid: uid ?? "", completion: { data in
                usernameText.text = data.pseudoname
            })
        }
    }
    
    func configureNavigationItems(){
                
        let title = UILabel()
        title.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        title.text = "Profile"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textAlignment = .left
        title.textColor = .heavenlyWhite
        self.navigationController?.navigationBar.backgroundColor = .midnights
        self.navigationItem.titleView = title
        self.navigationController?.navigationBar.barTintColor = .midnights
    }
    
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }

}
