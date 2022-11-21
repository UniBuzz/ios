//
//  FeedController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import Firebase
import Mixpanel

class FeedViewController: UIViewController {
    
    //MARK: - Variables
    private var viewModel = FeedViewModel()
    private var previousTabBarIndex = 0

    //MARK: - Properties
    private lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .midnights
        return tableView
    }()
    
    private lazy var addFeedButtonContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 56/2
        view.backgroundColor = .creamyYellow
        return view
    }()
    
    private lazy var addFeedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)), for: .normal)
        button.tintColor = .eternalBlack
        button.addTarget(self, action: #selector(addFeedButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let toggleHotAndNew = Toggle()
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItems()
        viewModel.fetchData()
        toggleHotAndNew.delegate = self
        feedTableView.delegate = self
        feedTableView.dataSource = self
        viewModel.delegate = self
        tabBarController?.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.trackEvent(event: "open_hive", properties: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Selector Functions
    @objc func addFeedButtonPressed() {
        let createFeedVC = PostFeedViewController()
        createFeedVC.delegate = self
        self.navigationController?.pushViewController(createFeedVC, animated: true)
    }
    
    @objc func searchButtonPressed() {
        viewModel.fetchData()
    }
    
    @objc func notificationButtonPressed() {
        
    }
    
    //MARK: - Functions
    
    func configureUI() {
        view.backgroundColor = .midnights
        self.view.addSubview(feedTableView)
        self.view.addSubview(addFeedButtonContainer)
        self.view.addSubview(toggleHotAndNew)
        addFeedButtonContainer.addSubview(addFeedButton)

        toggleHotAndNew.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(36)
        }
        
        feedTableView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(toggleHotAndNew.snp.bottom).offset(10)
            make.bottom.equalTo(view)
        }
        
        addFeedButtonContainer.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        addFeedButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        feedTableView.refreshControl = refreshControl
        feedTableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        feedTableView.backgroundView = activityIndicator
    }
    
    func configureNavigationItems(){
                
        let title = UILabel()
        title.frame = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        title.text = "Hive"
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.textAlignment = .left
        title.textColor = .heavenlyWhite
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonPressed))
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationButtonPressed))
        searchButton.tintColor = .heavenlyWhite
        notificationButton.tintColor = .heavenlyWhite
//        navigationItem.rightBarButtonItems = [notificationButton, searchButton]
        self.navigationController?.navigationBar.backgroundColor = .midnights
        self.navigationItem.titleView = title
        self.navigationController?.navigationBar.barTintColor = .midnights
    }
    
    @objc func refresh() {
        viewModel.fetchData()
    }
}

    //MARK: - Extension

extension FeedViewController: CellDelegate {
    
    func didTapComment(feed: Buzz, index: IndexPath) {
        let commentsViewModel = CommentsViewModel(feedBuzzTapped: feed)
        let commentsVC = CommentsViewController(commentsViewModel: commentsViewModel, parentIndexPath: index)
        self.navigationController?.pushViewController(commentsVC, animated: true)
        let properties = [
            "from": "\(Auth.auth().currentUser?.uid ?? "")",
            "buzz_content": "\(feed.content)"
        ]
        viewModel.trackEvent(event: "click_post", properties: properties)
    }
    
    func didTapUpVote(model: UpvoteModel, index: IndexPath) {
        viewModel.upVoteContent(model: model, index: index)
    }
    
    func didTapMessage(uid: String, pseudoname: String) {
        print(pseudoname)
        let controller = ChatCollectionViewController(user: User(dictionary: ["uid": uid, "pseudoname": pseudoname]))
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedViewController: PostFeedDelegate {
    func updateFeeds() {
        viewModel.fetchData()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let uid = Auth.auth().currentUser?.uid else { return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifier, for: indexPath) as! FeedTableViewCell
        let item = viewModel.feedsData
        let beeImage = UIImage(named: "mascot_dialogue_1")
        let beeImageView = UIImageView(image: beeImage)
        
        if indexPath.row == 0 {
            cell.beeImageView = beeImageView
        } else {
            cell.beeImageView = nil
        }
        
        cell.userUID = uid
        cell.cellViewModel = self.viewModel.getDataForFeedCell(feed: item[indexPath.row], indexPath: indexPath)
        cell.cellDelegate = self
        cell.updateDataSourceDelegate = self.viewModel
        cell.header.optionButtonPressedDelegate = self
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = viewModel.feedsData[indexPath.row]
        let commentsViewModel = CommentsViewModel(feedBuzzTapped: feed)
        let commentsVC = CommentsViewController(commentsViewModel: commentsViewModel, parentIndexPath: indexPath)
        commentsVC.updateDataSourceDelegate = self.viewModel
        self.navigationController?.pushViewController(commentsVC, animated: true)
        var properties = [
            "from": "\(Auth.auth().currentUser?.uid ?? "")",
            "buzz_content": "\(feed.content)"
        ]
        viewModel.trackEvent(event: "click_post", properties: properties)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.feedsData.count - 2 {
            viewModel.paginate()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.spacer(size: 20)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Header is used to give space for bee background
        return (250 / 2) - 40
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func stopRefresh() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    func reloadTableView() {
        feedTableView.reloadData()
    }
}

enum ReportFor {
    case account, buzz
}

extension FeedViewController: OptionButtonPressedDelegate {
    func optionButtonHandler(feed: Buzz) {
        let alert = UIAlertController(title: feed.userName, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report this post", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.reportAction(feed: feed, reportFor: .buzz)
            }
        }))
        alert.addAction(UIAlertAction(title: "Report Account", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.reportAction(feed: feed, reportFor: .account)
            }
        }))
        alert.addAction(UIAlertAction(title: "Block", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                self.viewModel.blockAccount(feed: feed)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true,completion: nil)
    }
    
    func reportAction(feed: Buzz, reportFor: ReportFor) {
        let alert = UIAlertController(title: nil, message: "Mengapa ingin melapor?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Spam", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Spam", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Spam", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Nudity atau aktivitas seksual", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Nudity atau aktivitas seksual", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Nudity atau aktivitas seksual", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Informasi yang salah", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Informasi yang salah", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Informasi yang salah", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Bullying atau pelecehan", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Bullying atau pelecehan", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Bullying atau pelecehan", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Ujaran kebencian", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Ujaran kebencian", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Ujaran kebencian", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Doxing", style: .default, handler: { _ in
                self.dismiss(animated: true) {
                    switch reportFor {
                    case .account:
                        self.viewModel.reportUser(reason: "Doxing", feed: feed)
                    case .buzz:
                        self.viewModel.reportHive(reason: "Doxing", feed: feed)
                    }
                    self.afterReportAction(feed: feed)
                }
        }))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
    func afterReportAction(feed: Buzz) {
        let alert = UIAlertController(title: nil, message: "Terima kasih, laporan kamu sudah masuk. Ini langkah berikutnya yang bisa kamu lakukan", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Blokir Akun", style: .destructive, handler: { _ in
                self.dismiss(animated: true) {
                    self.viewModel.blockAccount(feed: feed)
                    
                }
        }))
        alert.addAction(UIAlertAction(title: "Selesai", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
}

extension FeedViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == previousTabBarIndex {
            feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        previousTabBarIndex = tabBarIndex
    }
}

extension FeedViewController: ToggleDelegate {
    func changeSection(section: FeedSection) {
        viewModel.feedSection = section
        activityIndicator.startAnimating()
    }
}

