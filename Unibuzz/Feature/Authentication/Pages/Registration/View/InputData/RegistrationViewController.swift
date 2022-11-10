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
    private let viewModel: RegistrationViewModel
    
    private lazy var emailContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: emailTextField, title: "University Email")
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert your email")
        tf.addTarget(self, action: #selector(checkFormValid), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: passwordTextField, title: "Password")
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(checkFormValid), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var pseudoContainerView: UIView = {
        let view = InputThemes().inputContainerView(textfield: pseudoTextField, title: "Pseudoname")
        return view
    }()
    
    private lazy var pseudoTextField: UITextField = {
        let tf = InputThemes().textField(withPlaceholder: "insert pseudoname")
        tf.addTarget(self, action: #selector(checkFormValid), for: .editingDidEnd)
        return tf
    }()
    
    private lazy var registButton: UIButton = {
        let button = ButtonThemes(buttonTitle: "Create Account")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.backgroundColor = .storm
        button.isEnabled = false
        button.setTitleColor(.cloudSky, for: .normal)
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
    
    private lazy var agreeWithTermsConditionButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "I Agree with the ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.heavenlyWhite])
        attributedTitle.append(NSAttributedString(string: "terms and conditions", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.creamyYellow, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(agreeWithTermsAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var agreeWithTermsConditionChecklist: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox"), for: .normal)
        button.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        return button
    }()
    
    private var agreeWithTerms: Bool = false {
        didSet {
            if agreeWithTerms {
                agreeWithTermsConditionChecklist.setImage(UIImage(named: "checkbox-fill"), for: .normal)
            } else {
                agreeWithTermsConditionChecklist.setImage(UIImage(named: "checkbox"), for: .normal)
            }
            checkFormValid()
        }
    }
    
    private var agreeWithTermsClicked: Bool = false

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .heavenlyWhite
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
            let alert = UIAlertController(title: "Pseudoname not valid", message: "Total character for pseudoname are between 2 and 20 and not contains spaces", preferredStyle: .alert)
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
        
        self.hideKeyboardWhenTappedAround()
        
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
        
        view.addSubview(emailContainerView)
        emailContainerView.snp.makeConstraints { make in
            make.top.equalTo(tellUs.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(passwordContainerView)
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(emailContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(pseudoContainerView)
        pseudoContainerView.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [agreeWithTermsConditionChecklist, agreeWithTermsConditionButton])
        stack.axis = .horizontal
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(pseudoContainerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        view.addSubview(registButton)
        registButton.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
    }
    
    func showMustReadTermsCondition() {
        let alert = UIAlertController(title: "Terms and Conditions", message: "Read The terms and Condition first!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
    //MARK: - Selector
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
    
    @objc func checkFormValid(){
        if emailTextField.hasText && passwordTextField.hasText && pseudoTextField.hasText && agreeWithTerms {
            registButton.backgroundColor = .creamyYellow
            registButton.isEnabled = true
            registButton.setTitleColor(.eternalBlack, for: .normal)
        } else {
            registButton.backgroundColor = .storm
            registButton.isEnabled = false
            registButton.setTitleColor(.heavenlyWhite, for: .normal)
        }
        
    }
    
    @objc func agreeWithTermsAction() {
        if let url = URL(string: "https://www.unibuzz.app/terms-and-conditions"), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
            agreeWithTermsClicked = true
        }
    }
    
    @objc func handleAgree() {
        if agreeWithTermsClicked {
            agreeWithTerms.toggle()
        } else {
            showMustReadTermsCondition()
        }
    }
}

