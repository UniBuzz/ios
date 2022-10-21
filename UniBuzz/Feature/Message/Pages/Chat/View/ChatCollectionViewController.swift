//
//  ChatController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import UIKit
import SnapKit

private let reuseIdentifier = "MessageCell"

class ChatCollectionViewController: UICollectionViewController {
    
    // MARK: - properties
    private var viewModel = ChatViewModel()
    
    private lazy var CustomInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 67))
        iv.delegate = self
        return iv
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
       let spin = UIActivityIndicatorView()
        spin.sizeToFit()
        spin.style = .large
        spin.color = .heavenlyWhite
        return spin
    }()
    
    // MARK: - Lifecycle
    init(user: User){
        self.viewModel.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: user.pseudoname, preferredLargeTitle: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingSpinner.startAnimating()
        readMessage()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureUI()
        fectMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        readMessage()
    }
    
    override var inputAccessoryView: UIView? {
        get {return CustomInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - CollectionView Functions
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = viewModel.messages[indexPath.row]
        return cell
    }
    
    // MARK: - Functions and selectors
    func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        collectionView.backgroundColor = .midnights
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        view.addSubview(loadingSpinner)
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    // MARK: - fetch message API
    
    func readMessage() {
        viewModel.readMessage()
    }

    func fectMessages() {
        self.loadingSpinner.startAnimating()
        viewModel.fetchMessages {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,self.viewModel.messages.count - 1], at: .bottom, animated: true)
            self.loadingSpinner.stopAnimating()
        }
//        self.loadingSpinner.stopAnimating()
    }
}



    // MARK: - Extensions

extension ChatCollectionViewController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        viewModel.uploadMessage(message) {
            self.collectionView.scrollToItem(at: [0,self.viewModel.messages.count - 1], at: .bottom, animated: true)
        }
    }
}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = viewModel.messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 500)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
}
