//
//  CreateFeedViewController.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 23/09/22.
//

import UIKit

class PostFeedViewController: UIViewController {

    //MARK: - Variables
    
    //MARK: - Properties
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textColor = .heavenlyWhite
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var postButton: UIView = {
        let view = UIView()
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(view).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-10)
        }
        view.backgroundColor = .creamyYellow
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .stoneGrey
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .stoneGrey
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.contentVerticalAlignment = .top
        return tf
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's in your mind?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(textField.text?.count ?? 0)/150"
        label.textColor = .cloudSky
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your thoughts"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .cloudSky
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Selector Functions
    @objc func textFieldDidChange() {
        textField.text == "" ? showPlaceHolder() : placeHolderLabel.removeFromSuperview()
        characterCountLabel.text = "\(textField.text?.count ?? 0)/150"
    }
    
    @objc func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postButtonPressed() {
        print("post pressed")
    }
    
    //MARK: - Functions
    func configureUI() {
        self.view.backgroundColor = .midnights
        self.navigationItem.hidesBackButton = true
        
        view.addSubview(cancelButton)
        view.addSubview(postButton)
        view.addSubview(textField)
        view.addSubview(titleLabel)
        view.addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)
        view.addSubview(characterCountLabel)

        showPlaceHolder()
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        postButton.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(cancelButton)
            make.width.equalTo(81)
            make.height.equalTo(37)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(30)
            make.left.equalTo(cancelButton)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(185)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer).offset(20)
            make.left.equalTo(textFieldContainer).offset(20)
            make.right.equalTo(textFieldContainer).offset(-20)
            make.bottom.equalTo(textFieldContainer).offset(-20)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.right.equalTo(textFieldContainer.snp.right).offset(-20)
            make.bottom.equalTo(textFieldContainer.snp.bottom).offset(-20)
        }
    }
    
    func showPlaceHolder() {
        view.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.left.equalTo(textFieldContainer).offset(20)
            make.top.equalTo(textFieldContainer).offset(22)
        }
    }
}
