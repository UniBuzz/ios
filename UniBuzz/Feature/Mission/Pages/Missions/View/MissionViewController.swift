//
//  MissionController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 19/09/22.
//

import UIKit

class MissionViewController: UIViewController {

    //MARK: - Properties
    lazy var titleText: UILabel = {
        var label: UILabel = UILabel()
        label.text = "Mission"
        return label
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
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
