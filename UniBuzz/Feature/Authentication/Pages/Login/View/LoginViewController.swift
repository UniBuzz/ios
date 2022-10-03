//
//  LoginViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 23/09/22.
//

import UIKit
import SnapKit
import Firebase

protocol AuthenticationDelegate: AnyObject {
    func authenticationComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AuthenticationDelegate?
    
    private let viewModel = LoginViewModel()
    
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.backgroundColor = .creamyYellow
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = InputThemes().attributtedButton("Don't have an account? ", "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView()
        spin.sizeToFit()
        spin.style = .large
        spin.backgroundColor = .eternalBlack
        spin.color = .heavenlyWhite
        return spin
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        overrideUserInterfaceStyle = .dark
    }
    // MARK: - Helpers
    
    func bindViewModel(){
        viewModel.errorPresentView = { error in
            print("DEBUG: error with message - \(error.localizedDescription)")
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.loadingSpinner.stopAnimating()
            self.loginButton.isEnabled = true
            self.present(alert, animated: true,completion: nil)
        }
        
        viewModel.authSuccess = {
            self.loadingSpinner.stopAnimating()
            self.loginButton.isEnabled = true
            self.delegate?.authenticationComplete()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .midnights
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(loginButton)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(loadingSpinner)
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview()
        }
        
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        dontHaveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }

    @objc func handleShowSignUp() {
        let controller = MainRegistrationViewController()
//        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return  }
        guard let password = passwordTextField.text else { return  }
        loadingSpinner.startAnimating()
        loginButton.isEnabled = false
        viewModel.signIn(withEmail: email, password: password)
    }
}
