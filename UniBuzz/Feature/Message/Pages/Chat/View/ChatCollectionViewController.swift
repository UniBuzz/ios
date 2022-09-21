//
//  ChatController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 20/09/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController {
    
    // MARK: - properties
    private lazy var CustomInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 67))
        return iv
    }()
    
    // MARK: - Lifecycle
    init(user: String){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationItem.title = user
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
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    // MARK: - Functions and selectors
    func configureUI() {
        collectionView.backgroundColor = .midnights
        configureNavigationBar()
    }
    
    func configureNavigationBar() {


    }
}
