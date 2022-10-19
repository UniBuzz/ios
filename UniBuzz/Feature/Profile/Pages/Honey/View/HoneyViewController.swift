//
//  HoneyViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 06/10/22.
//

import UIKit
import SnapKit

class HoneyViewController: UIViewController {

    //MARK: - Properties
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Engage more with the community such as creating posts, upvoting, replying to comments, and getting your comments upvoted!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.textColor = .heavenlyWhite
        return label
    }()
    
    lazy var earnHoney = EarnMoneyView()
    lazy var useHoney = UseHoneyView()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Functions
    func configureUI() {
        view.backgroundColor = .midnights
        configureNavigationBar(largeTitleColor: .heavenlyWhite, backgoundColor: .midnights, tintColor: .heavenlyWhite, title: "Drops of Honey", preferredLargeTitle: false)
        
        view.addSubview(descLabel)
        view.addSubview(earnHoney)
        view.addSubview(useHoney)
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        earnHoney.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(25)
            make.left.equalTo(descLabel.snp.left)
            make.right.equalTo(descLabel.snp.right)
            make.height.equalTo(198)
        }
        useHoney.snp.makeConstraints { make in
            make.top.equalTo(earnHoney.snp.bottom).offset(25)
            make.left.equalTo(descLabel.snp.left)
            make.right.equalTo(descLabel.snp.right)
            make.height.equalTo(136)
        }
    }
}
