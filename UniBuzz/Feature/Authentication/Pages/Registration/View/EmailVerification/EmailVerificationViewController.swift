//
//  EmailVerificationViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 05/10/22.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    
    //MARK: - Properties
    private let pageControl: UIView = {
        let control = PageControlView(page: 3)
        return control
    }()
    
    private let verifyAccount: UILabel = {
        let label = UILabel()
        label.text = "Verify Your Account"
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let sendEmail: UILabel = {
        let label = UILabel()
        label.text = "We sent you a verification link to"
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let emailAccount: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var resendVerification: UIButton = {
        let button = ButtonThemes(buttonTitle: "Resend")
//        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .stoneGrey
        return button
    }()
    
    private lazy var backToLogin: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Back to Login", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.creamyYellow])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleBackLogin), for: .touchUpInside)
        return button
    }()
    
    let viewModel: RegistrationViewModel
    let email: String
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    init(viewModel: RegistrationViewModel = RegistrationViewModel(), email: String){
        self.viewModel = viewModel
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helper
    func configureUI(){
        view.backgroundColor = .midnights
        navigationItem.hidesBackButton = true
        emailAccount.text = email
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(verifyAccount)
        verifyAccount.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let stack = UIStackView(arrangedSubviews: [sendEmail,emailAccount])
        stack.axis = .vertical
        stack.spacing = 5
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(verifyAccount.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(resendVerification)
        resendVerification.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(140)
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backToLogin)
        backToLogin.snp.makeConstraints { make in
            make.top.equalTo(resendVerification.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
    }
    
    //MARK: - Selector
    
    @objc func handleBackLogin(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
