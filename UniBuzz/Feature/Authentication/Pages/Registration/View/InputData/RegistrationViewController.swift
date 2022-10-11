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
    weak var delegate: AuthenticationDelegate?
    private let viewModel: RegistrationViewModel
    
    private lazy var emailContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: emailTextField, title: "University Email")
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert your email")
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: passwordTextField, title: "Password")
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var pseudoContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: pseudoTextField, title: "Pseudoname")
        return view
    }()
    
    private lazy var pseudoTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert pseudoname")
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var registButton: UIButton = {
        let button = ButtonThemes(buttonTitle: "Create Account")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.backgroundColor = .storm
        button.isEnabled = false
        button.setTitleColor(.heavenlyWhite, for: .normal)
        return button
    }()
    
    private lazy var pageControl: UIView = {
        let control = PageControlView(page: 2)
        return control
    }()
    
    private lazy var tellUs: UILabel = {
        let label = UILabel()
        label.text = "Tell us about yourself"
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
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
    init(viewModel: RegistrationViewModel = RegistrationViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        overrideUserInterfaceStyle = .dark
    }
    
    
    // MARK: - Helpers
    
    func bindViewModel(){
        viewModel.errorRegisterView = { error in
            print("DEBUG: Error with error value -> \(error)")
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.loadingSpinner.stopAnimating()
            self.registButton.isEnabled = true
            self.present(alert, animated: true,completion: nil)
        }
        
        viewModel.successRegisterView = {
            self.loadingSpinner.stopAnimating()
            self.registButton.isEnabled = true
            self.viewModel.sendVerificationEmail()
            self.navigationController?.pushViewController(EmailVerificationViewController(viewModel: self.viewModel, email: self.emailTextField.text ?? ""), animated: true)
        }
        
        viewModel.enableButton = {
            self.registButton.backgroundColor = .creamyYellow
            self.registButton.isEnabled = true
            self.registButton.setTitleColor(.eternalBlack, for: .normal)
        }
        
        viewModel.errorEmailNotValid = {
            let alert = UIAlertController(title: "Email not valid", message: "Please input your university email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.loadingSpinner.stopAnimating()
            self.present(alert, animated: true,completion: nil)
        }
        
        viewModel.pseudonameNotPassed = {
            let alert = UIAlertController(title: "Pseudoname not valid", message: "Total character for pseudoname are between 2 and 20", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.loadingSpinner.stopAnimating()
            self.present(alert, animated: true,completion: nil)
        }
        
        viewModel.pseudonameExists = {
            let alert = UIAlertController(title: "Pseudoname exists", message: "Pseudoname that you input already exists!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.loadingSpinner.stopAnimating()
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    
    func configureUI() {
        view.backgroundColor = .midnights
        let backButton = UIBarButtonItem()
        backButton.title = "Sign Up"
        backButton.tintColor = .heavenlyWhite
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(pseudoContainerView)
        view.addSubview(registButton)
        view.addSubview(loadingSpinner)
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(tellUs)
        tellUs.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(tellUs.snp.bottom).offset(40)
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
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let pseudo = pseudoTextField.text else {return}
        
        loadingSpinner.startAnimating()
        registButton.isEnabled = false
        
        viewModel.registerUser(withEmail: email, pseudo: pseudo, password: password)
        
    }
    
    @objc func handleTextChange(){
        if emailTextField.hasText && passwordTextField.hasText && passwordTextField.hasText {
            registButton.backgroundColor = .creamyYellow
            registButton.isEnabled = true
            registButton.setTitleColor(.eternalBlack, for: .normal)
        }
        
    }

}

