//
//  ProfileController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit

class ProfileController: UIViewController {

    lazy var titleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Profile"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureUI()
    }
    
    func configureUI() {
        self.view.addSubview(titleText)
        titleText.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }

}
