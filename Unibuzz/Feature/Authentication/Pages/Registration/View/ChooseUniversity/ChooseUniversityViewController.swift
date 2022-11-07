//
//  MainRegistrationViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 30/09/22.
//

import UIKit
import SnapKit


class ChooseUniversityViewController: UIViewController {
    
    
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
        button.backgroundColor = .storm
        button.isEnabled = false
        button.setTitleColor(.heavenlyWhite, for: .normal)
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
        bindViewModel()
        injectViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - Helper
    
    func configureUI(){
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .midnights
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(140)
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
    
    func injectViewModel(){
        universityView.viewModel = viewModel
    }
    
    func bindViewModel(){
        viewModel.enableButton = {
            self.chooseUniButton.backgroundColor = .creamyYellow
            self.chooseUniButton.isEnabled = true
            self.chooseUniButton.setTitleColor(.eternalBlack, for: .normal)
        }
    }

    
    //MARK: - Selector
    
    @objc func nextPage(){
        let vc = RegistrationViewController(viewModel: viewModel)
        if viewModel.universitySelected != nil {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Choose your University", message: "Please choose your University", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
        
    }
    
    @objc func handleBackLogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
