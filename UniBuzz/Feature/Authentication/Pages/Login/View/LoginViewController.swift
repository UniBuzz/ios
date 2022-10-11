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
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributtedTitle = NSMutableAttributedString(string: "Forgot your password?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(attributtedTitle, for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
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
        
        viewModel.notVerified = {
            let alert = UIAlertController(title: "Email not Verified", message: "Please, verify your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Resend verification", style: .default, handler: { _ in
                self.viewModel.resendVerificationEmail()
            }))
            self.loadingSpinner.stopAnimating()
            self.loginButton.isEnabled = true
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .midnights
        
        let backButton = UIBarButtonItem()
        backButton.title = "Login"
        backButton.tintColor = .heavenlyWhite
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(emailContainerView)
        emailContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(passwordContainerView)
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
    //MARK: - Selector
    @objc func handleShowSignUp() {
        let controller = ChooseUniversityViewController()
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
    
    @objc func forgotPassword() {
        let controller = ForgotPasswordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
