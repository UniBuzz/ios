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
    private let maxCharacters = 150
    
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
        view.backgroundColor = .stoneGrey
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
        button.setTitleColor(.heavenlyWhite, for: .disabled)
        button.isEnabled = false
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
    
    private lazy var textField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .stoneGrey
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.delegate = self
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .cloudSky
        return label
    }()
    
    private lazy var beeBackgroundImage: UIImageView = {
        let beeImage = UIImage(named: "spill_dialogue_1")
        let beeBackgroundImage = UIImageView(image: beeImage)
        return beeBackgroundImage
    }()
    
    private var beeImageHeightConstant = NSLayoutConstraint()
    
    //MARK: - Lifecycle
    internal override func viewDidLoad() {
        super.viewDidLoad()
        beeImageHeightConstant = NSLayoutConstraint(item: beeBackgroundImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 230)
        hideKeyboardWhenTappedAround()
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
        }
        beeImageHeightConstant.isActive = true
        
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
            make.top.equalTo(beeBackgroundImage.snp.centerY).offset(20)
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
            make.left.equalTo(textField).offset(8)
            make.top.equalTo(textField).offset((textField.font?.pointSize)! / 2)
        }
    }
}

extension PostFeedViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxCharacters + 1
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            showPlaceHolder()
            postButtonContainer.backgroundColor = .stoneGrey
            postButton.isEnabled = false
        } else {
            placeHolderLabel.removeFromSuperview()
            postButtonContainer.backgroundColor = .creamyYellow
            postButton.isEnabled = true
        }
        characterCountLabel.text = "\(textView.text?.count ?? 0)/\(maxCharacters)"
    }
}
