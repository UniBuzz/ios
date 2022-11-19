//
//  ProfileController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit

protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
    func handleDeleteAccount()
}

class ProfileViewController: UIViewController {

    //MARK: - Properties
    weak var delegate: ProfileControllerDelegate?
    let viewModel = ProfileViewModel()
    
    lazy var usernameText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Pseudoname"
        label.textColor = .creamyYellow
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let avatarImageView = AvatarGenerator(pseudoname: "", background: 0)
    let honeyJarImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Honey_jar")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dropsOfHoney = DropsOfHoneyView()
    let changePseudo = ChangePseudonameView()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .midnights
        configureUI()
        configureNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserHoney()
        viewModel.trackEvent(event: "click_profile", properties: nil)
    }
    
    //MARK: - Functions
    func configureUI() {
        self.view.addSubview(avatarImageView)
        self.view.addSubview(usernameText)
        self.view.addSubview(honeyJarImage)
        self.view.addSubview(dropsOfHoney)
        self.view.addSubview(changePseudo)

        self.navigationController?.navigationBar.tintColor = .midnights
        self.navigationController?.navigationBar.barTintColor = .midnights
        self.navigationController?.navigationBar.backgroundColor = .midnights
        
        avatarImageView.layer.cornerRadius = 80/2
        avatarImageView.nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalTo(self.view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        usernameText.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        
        honeyJarImage.snp.makeConstraints { make in
            make.top.equalTo(usernameText.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
        }
        
        let honeyTapGesture = UITapGestureRecognizer(target: self, action: #selector(honeyButtonPressed))
        dropsOfHoney.addGestureRecognizer(honeyTapGesture)
        dropsOfHoney.snp.makeConstraints { make in
            make.top.equalTo(honeyJarImage.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(62)
        }
        
        changePseudo.snp.makeConstraints { make in
            make.top.equalTo(dropsOfHoney.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(113)
        }
        changePseudo.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        
        getUserPseudoname()
        
    }
    
    func getUserPseudoname() {
        viewModel.fetchCurrentUser { user in
            self.usernameText.text = user.pseudoname
            self.avatarImageView.pseudoname = user.pseudoname
            self.avatarImageView.randomInt = user.randomInt
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
    
    func getUserHoney() {
        Task.init {
            let honey = await viewModel.getCurrentUserHoney()
            DispatchQueue.main.async {
                if honey < 200 {
                    self.changePseudo.changeButton.isEnabled = false
                    self.changePseudo.currentHoneyLabel.textColor = .cloudSky
                    self.changePseudo.neededHoneyLabel.textColor = .cloudSky
                } else {
                    self.changePseudo.changeButton.isEnabled = true
                    self.changePseudo.currentHoneyLabel.textColor = .creamyYellow
                    self.changePseudo.neededHoneyLabel.textColor = .creamyYellow
                }
                self.changePseudo.currentHoneyLabel.text = String(honey)
                self.dropsOfHoney.totalHoneyLabel.text = String(honey)
            }
        }
    }
    
    @objc func settingButtonPressed() {
        let settings = SettingsViewController()
        settings.delegate = self
        navigationController?.pushViewController(settings, animated: true)
    }
    
    @objc func honeyButtonPressed(sender: UITapGestureRecognizer) {
        let honey = HoneyViewController()
        viewModel.trackEvent(event: "click_dropofhoney", properties: ["totalhoney": viewModel.totalHoney])
        navigationController?.pushViewController(honey, animated: true)
    }
    
    @objc func changeButtonTapped() {
        let changePseudo = ChangePseudonameViewController()
        changePseudo.delegate = self
        changePseudo.userPseudonameText.text = usernameText.text
        viewModel.trackEvent(event: "change_pseudoname", properties: ["totalhoney": viewModel.totalHoney])
        navigationController?.pushViewController(changePseudo, animated: true)
    }
}

    //MARK: - Extensions

extension ProfileViewController: SettingsProfileDelegate {
    func handleLogout() {
        delegate?.handleLogout()
    }
    
    func handleDeleteAccount() {
        delegate?.handleDeleteAccount()
    }
}

extension ProfileViewController: ChangePseudonameDelegate {
    func changePseudoname(newName: String) {
        Task.init {
            await viewModel.changePseudoname(newName: newName)
            getUserPseudoname()
        }
    }
    
    func decrementHoney() {
        Task.init {
            await viewModel.decrementHoneyChangePseudoname()
            getUserHoney()
        }
    }
}


