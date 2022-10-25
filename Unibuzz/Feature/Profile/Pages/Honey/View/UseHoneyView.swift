//
//  UseHoneyView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 08/10/22.
//

import UIKit
import SnapKit

class UseHoneyView: UIView {
    // MARK: - Properties
    lazy var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .heavenlyWhite
        label.text = "You can use honey to"
        return label
    }()
    
    lazy var changePseudo = HoneyItemView(title: "Change Pseudoname", honey: "200")
    lazy var createChannel = HoneyItemView(title: "Create Channel", honey: "Soon")

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
            changePseudo,
            createChannel
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

