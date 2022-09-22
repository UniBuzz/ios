//
//  ChatController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class ChatCollectionViewController: UICollectionViewController {
    
    // MARK: - properties
    private lazy var CustomInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 67))
        iv.delegate = self
        return iv
    }()
    
    var messages: [Message] = [Message(text: "test", toId: "notme", fromId: "me"),Message(text: "lol", toId: "notme", fromId: "me"),Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", toId: "notme", fromId: "me")]
    
    // MARK: - Lifecycle
    init(user: String){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: user, preferredLargeTitle: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureUI()
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
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    // MARK: - Functions and selectors
    func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        collectionView.backgroundColor = .midnights
        configureNavigationBar()
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    func configureNavigationBar() {
    
    }
}

    // MARK: - Functions and selectors

extension ChatCollectionViewController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        messages.append(Message(text: message, toId: "NotMe", fromId: "Me"))
        print(messages)
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: [0,self.messages.count - 1], at: .bottom, animated: true)
    }
}

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 500)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 50)
//    }
}
