//
//  CreateFeedViewController.swift
//  UniBuzz
//
//  Created by Hada Melino Muhammad on 23/09/22.
//

import UIKit

protocol PostFeedDelegate: AnyObject {
    func updateFeeds()
}

class PostFeedViewController: UIViewController {

    //MARK: - Variables
    private let viewModel = PostFeedViewModel()
    internal weak var delegate: PostFeedDelegate?
    
    //MARK: - Properties
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textColor = .heavenlyWhite
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var postButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .creamyYellow
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buzz", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.eternalBlack, for: .normal)
        button.addTarget(self, action: #selector(postButtonPresseds), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .stoneGrey
        view.layer.borderColor = UIColor.creamyYellow.withAlphaComponent(0.4).cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .stoneGrey
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.contentVerticalAlignment = .top
        return tf
    }()

    private lazy var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(textField.text?.count ?? 0)/150"
        label.textColor = .cloudSky
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your thoughts"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .cloudSky
        return label
    }()
    
    private lazy var beeBackgroundImage: UIImageView = {
        let beeImage = UIImage(named: "spill_dialogue_1")
        let beeBackgroundImage = UIImageView(image: beeImage)
        return beeBackgroundImage
    }()
    
    //MARK: - Lifecycle
    internal override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
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
    
    @objc func postButtonPresseds() {
        Task.init {
            await viewModel.uploadFeed(content: textField.text ?? "")
            delegate?.updateFeeds()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Functions
    private func configureUI() {
        self.view.backgroundColor = .midnights
        self.navigationItem.hidesBackButton = true
        
        view.addSubview(beeBackgroundImage)
        view.addSubview(cancelButton)
        view.addSubview(textFieldContainer)
        view.addSubview(characterCountLabel)
        view.addSubview(postButtonContainer)
        textFieldContainer.addSubview(textField)
        postButtonContainer.addSubview(postButton)

        showPlaceHolder()
        
        beeBackgroundImage.snp.makeConstraints { make in
            make.top.equalTo(cancelButton).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        postButtonContainer.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(cancelButton)
            make.width.equalTo(81)
            make.height.equalTo(37)
        }

        postButton.snp.makeConstraints { make in
            make.top.equalTo(postButtonContainer).offset(10)
            make.left.equalTo(postButtonContainer).offset(20)
            make.right.equalTo(postButtonContainer).offset(-20)
            make.bottom.equalTo(postButtonContainer).offset(-10)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(beeBackgroundImage.snp.top).offset(beeBackgroundImage.frame.height / 2)
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
    
    private func showPlaceHolder() {
        view.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.left.equalTo(textFieldContainer).offset(20)
            make.top.equalTo(textFieldContainer).offset(22)
        }
    }
}
