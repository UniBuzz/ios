//
//  ConversationController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit
import SnapKit

class ConversationController: UIViewController {
    
    lazy var titleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Conversations"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureUI()
    }
    
    func configureUI() {
        self.view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
    
}
