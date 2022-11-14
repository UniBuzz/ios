//
//  DeleteUserViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//


import UIKit
import SnapKit

protocol DeleteAccountProfileDelegate: AnyObject {
    func handleDeleteAccount()
}

class DeleteUserViewController: UIViewController {

    //MARK: - Properties
    weak var delegate: DeleteAccountProfileDelegate?
    lazy var viewmodel = DeleteUserViewModel()
    lazy var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .heavenlyWhite
        label.text = "This will delete your account"
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .cloudSky
        label.text = "Delete your account from UniBuzz permanently."
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(UIColor.warningRed, for: .normal)
        button.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        return button
    }()
    lazy var textField = UITextField()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Delete Account", preferredLargeTitle: false)
        
        view.addSubview(tittleLabel)
        view.addSubview(descLabel)
        view.addSubview(deleteButton)
        
        tittleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(tittleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(tittleLabel)
        }
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.centerX.equalToSuperview()
        }
        
        }
    
    @objc func deleteClicked() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want delete your account from Unibuzz permanently?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.dismiss(animated: true) {
                        self.deleteUsingPassword()
                    }
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }
    
    func deleteUsingPassword() {
        let alert = UIAlertController(title: nil, message: "Enter your password to delete", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
         }
        let ok = UIAlertAction(title: "Delete",
                               style: .destructive) { (action: UIAlertAction) in
                            if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                self.deleteAccount(password: alertTextField.text!)
                            }


          }
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }
    
    func alertError(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }
    
    func deleteAccount(password: String) {
        
        viewmodel.reauthenticateUser(password) { passwordError in
            if let passwordError {
                self.alertError(passwordError)
            }else {
                self.viewmodel.deleteUser { deleteError in
                    if let deleteError {
                        self.alertError(deleteError)
                    }else {
                        print("DEBUG Account deleted.")
                        self.delegate?.handleDeleteAccount()
                    }
                }
                self.viewmodel.deletePersistent()
            }
        }
        

        

    }
}

