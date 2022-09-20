//
//  FeedController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit

class FeedViewController: UIViewController {

    //MARK: - Properties
    lazy var titleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Feeds"
        return label
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        self.view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}
