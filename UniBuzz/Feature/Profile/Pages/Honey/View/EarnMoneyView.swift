//
//  EarnMoneyView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 08/10/22.
//

import UIKit
import SnapKit

class EarnMoneyView: UIView {
    // MARK: - Properties
    var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .heavenlyWhite
        label.text = "How to earn Honey"
        return label
    }()
    
    var receivingComments = HoneyItemView(title: "Receiving Comments", honey: "20")
    var commentsUpvote = HoneyItemView(title: "Comments getting upvoted", honey: "15")
    var postUpvote = HoneyItemView(title: "Post getting upvoted", honey: "5")
    var givingUpvote = HoneyItemView(title: "Giving upvotes", honey: "1")

    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        configureUI()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configureUI() {
        self.backgroundColor = .stoneGrey
        self.layer.borderColor = UIColor.creamyYellow.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.addSubview(tittleLabel)
        let stackH = UIStackView(arrangedSubviews: [
            receivingComments,
            commentsUpvote,
            postUpvote,
            givingUpvote
        ])
        stackH.axis = .vertical
        stackH.spacing = 8
        self.addSubview(stackH)

        tittleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
        }
        
        stackH.snp.makeConstraints { make in
            make.top.equalTo(tittleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
}
