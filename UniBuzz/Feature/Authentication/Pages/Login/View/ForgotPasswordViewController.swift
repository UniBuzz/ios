//
//  ForgotPasswordViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 11/10/22.
//

import UIKit


class ForgotPasswordViewController: UIViewController {
    
    //MARK: - Properties
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.textColor = .creamyYellow
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t worry! It happens, please enter your university email."
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let emailTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert your email")
        return tf
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: emailTextField, title: "University Email")
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.backgroundColor = .creamyYellow
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
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
    
    private let viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    //MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .midnights
        
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headingLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(emailContainerView)
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        
    }
    
    func bindViewModel(){
        viewModel.errorPresentView = { error in
            print("DEBUG: error with message - \(error.localizedDescription)")
            self.loadingSpinner.stopAnimating()
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
        
        viewModel.forgotPasswordSuccess = {
            self.loadingSpinner.stopAnimating()
            let alert = UIAlertController(title: "Please check your email", message: "Forgot password link has been sent to your email address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    //MARK: - Selector
    
    @objc func handleSubmit(){
        guard let email = emailTextField.text else { return }
        loadingSpinner.startAnimating()
        viewModel.forgotPassword(email: email)
    }
    
    
}
