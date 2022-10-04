//
//  MainRegistrationViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 30/09/22.
//

import UIKit
import SnapKit


class MainRegistrationViewController: UIViewController {
    
    
    //MARK: - Properties
    
    private lazy var universityView = ChooseUniversityView()
    private lazy var chooseUni: UILabel = {
        let label = UILabel()
        label.text = "Choose your University"
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private lazy var chooseUniButton: UIButton = {
        let button = ButtonThemes(buttonTitle: "Tell us about yourself")
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Log In", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleBackLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIView = {
        let control = PageControlView(page: 1)
        return control
    }()
    
    
    let viewModel = RegistrationViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = false
    }
    
    //MARK: - Helper
    
    func configureUI(){
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .midnights
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        
        view.addSubview(chooseUni)
        chooseUni.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(universityView)
        universityView.snp.makeConstraints { make in
            make.top.equalTo(chooseUni.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
        }

        view.addSubview(chooseUniButton)
        chooseUniButton.snp.makeConstraints { make in
            make.top.equalTo(universityView.snp.bottom).offset(20)
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(chooseUniButton.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
    }

    
    //MARK: - Selector
    
    @objc func nextPage(){
        let vc = RegistrationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleBackLogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
