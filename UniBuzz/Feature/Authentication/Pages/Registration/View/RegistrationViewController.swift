//
//  RegistrationViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 23/09/22.
//

import UIKit
import SnapKit
import Firebase

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    
    private lazy var emailContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: emailTextField, title: "University Email")
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "email@ui.ac.id")
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: passwordTextField, title: "Password")
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var pseudoContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: pseudoTextField, title: "Pseudoname")
        return view
    }()
    
    private let pseudoTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "Maba_ezz_123")
        return tf
    }()
    
    private let registButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.backgroundColor = .creamyYellow
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let haveAccountButton: UIButton = {
        let button = InputThemes().attributtedButton("Already have an account? ", "Log in")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = false
    }
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .midnights
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(pseudoContainerView)
        view.addSubview(registButton)
        view.addSubview(haveAccountButton)
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview()
        }
        
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        pseudoContainerView.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        registButton.snp.makeConstraints { make in
            make.top.equalTo(pseudoContainerView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        haveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(registButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let pseudo = pseudoTextField.text else {return}
        
        print(email)
        print(password)
        print(pseudo)

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error {
                print("DEBUG: Error with error value -> \(error)")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let data = ["email" : email, "pseudoname" : pseudo, "uid" : uid] as [String : Any]
            Firestore.firestore().collection("users").document(uid).setData(data) { error in
                print("DEBUG: Did create user")
                
                if let error {
                    print("DEBUG: Firestore error with error value -> \(error.localizedDescription)")
                    return
                }
            }
            
        }
    }

}

