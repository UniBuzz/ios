//
//  ProfileController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase
import SnapKit

protocol ProfileControllerDelegate: AnyObject {
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
    
    let dropsOfHoney = DropsOfHoneyView()

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
        self.view.addSubview(dropsOfHoney)

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
        
        let honeyTapGesture = UITapGestureRecognizer(target: self, action: #selector(honeyButtonPressed))
        dropsOfHoney.addGestureRecognizer(honeyTapGesture)
        dropsOfHoney.snp.makeConstraints { make in
            make.top.equalTo(usernameText.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(62)
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
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingButtonPressed))
        settingsButton.tintColor = .heavenlyWhite
        navigationItem.rightBarButtonItem = settingsButton
        
        self.navigationController?.navigationBar.backgroundColor = .midnights
        self.navigationItem.titleView = title
        self.navigationController?.navigationBar.barTintColor = .midnights
    }
    
    @objc func settingButtonPressed() {
        let settings = SettingsViewController()
        settings.delegate = self
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc func honeyButtonPressed(sender: UITapGestureRecognizer) {
        let honey = HoneyViewController()
        navigationController?.pushViewController(honey, animated: true)
    }
}

    //MARK: - Extensions

extension ProfileViewController: SettingsProfileDelegate {
    func handleLogout() {
        delegate?.handleLogout()
    }
}
