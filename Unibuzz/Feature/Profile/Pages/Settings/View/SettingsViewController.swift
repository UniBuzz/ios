//
//  SettingsViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 05/10/22.
//

import UIKit

protocol SettingsProfileDelegate: AnyObject {
    func handleLogout()
    func handleDeleteAccount()
}

class SettingsViewController: UIViewController {

    //MARK: - Properties
    weak var delegate: SettingsProfileDelegate?
    fileprivate let reuseIdentifier = "SettingsCell"
    private let tableView = UITableView()
    let viewModel = SettingsViewModel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    //MARK: - Functions
    
    func bindViewModel() {
        viewModel.logOutView = {
            let newViewControllers = NSMutableArray()
            let loginVC = LoginViewController()
            loginVC.hidesBottomBarWhenPushed = true
            newViewControllers.add(loginVC)
            self.navigationController?.setViewControllers(newViewControllers as! [UIViewController], animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Settings", preferredLargeTitle: false)
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        tableView.backgroundColor = .midnights
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsItemViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(LogoutViewCell.self, forCellReuseIdentifier: "LogoutCell")
    }
    
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.viewModel.logOut()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }

}

//MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.numberOfItems() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! LogoutViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsItemViewCell
            cell.tittleLabel.text = viewModel.titleItem(indexPath.row)
            cell.descriptionLabel.text = viewModel.descriptionItem(indexPath.row)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems() {
            handleLogout()
        }else if indexPath.row == 4 {
            let deletePage = DeleteUserViewController()
            deletePage.delegate = self
            navigationController?.pushViewController(deletePage, animated: true)
        } else if indexPath.row == 0{
            var webPage = WebViewController()
            webPage.link = "https://www.unibuzz.app/community-guidelines"
            navigationController?.pushViewController(webPage, animated: true)
        } else if indexPath.row == 1{
            var webPage = WebViewController()
            webPage.link = "https://www.unibuzz.app/Privacy-and-safety"
            navigationController?.pushViewController(webPage, animated: true)
        } else {
            var webPage = WebViewController()
            webPage.link = "https://www.unibuzz.app"
            navigationController?.pushViewController(webPage, animated: true)
        }

    }
    
}

// MARK: - Extensions

extension SettingsViewController: DeleteAccountProfileDelegate{
    func handleDeleteAccount() {
        delegate?.handleDeleteAccount()
    }
}
