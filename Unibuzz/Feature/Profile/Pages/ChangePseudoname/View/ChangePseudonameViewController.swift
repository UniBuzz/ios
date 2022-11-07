//
//  ChangePseudonameViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 07/10/22.
//

import UIKit
import SnapKit

protocol ChangePseudonameDelegate: AnyObject {
    func decrementHoney()
}

class ChangePseudonameViewController: UIViewController {
    
    //MARK: - Properties
    lazy var currentTitleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Current Pseudoname"
        label.textColor = .heavenlyWhite
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var userPseudonameText: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.textColor = .heavenlyWhite
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var newTitleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "New Pseudoname"
        label.textColor = .heavenlyWhite
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var inputTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .stoneGrey
        tv.autocorrectionType = .no
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = true
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 10, bottom: 3, right: 10)
        return tv
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "new_pseudoname"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    lazy var changeButton = ButtonThemes(buttonTitle: "Done")
    
    weak var delegate: ChangePseudonameDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Change Pseudoname", preferredLargeTitle: false)
        view.addSubview(currentTitleText)
        view.addSubview(userPseudonameText)
        view.addSubview(newTitleText)
        view.addSubview(inputTextView)
        view.addSubview(placeholderLabel)
        view.addSubview(changeButton)
        
        changeButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        currentTitleText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.left.equalToSuperview().offset(30)
        }
        
        userPseudonameText.snp.makeConstraints { make in
            make.top.equalTo(currentTitleText.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
        }
        
        newTitleText.snp.makeConstraints { make in
            make.top.equalTo(userPseudonameText.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(newTitleText.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(30)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.top).offset(4)
            make.left.equalTo(inputTextView.snp.left).offset(15)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        changeButton.layer.cornerRadius = 50/2
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.inputTextView.text.isEmpty
    }
    
    @objc func doneButtonPressed() {
        delegate?.decrementHoney()
        navigationController?.popViewController(animated: true)
    }
}
