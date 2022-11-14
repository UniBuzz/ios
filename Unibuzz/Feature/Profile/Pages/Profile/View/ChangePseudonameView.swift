//
//  ChangePseudonameView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 07/10/22.
//

import UIKit
import SnapKit

class ChangePseudonameView: UIView {
    
    //MARK: - Properties
    var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .heavenlyWhite
        label.text = "Change Pseudoname"
        return label
    }()
    
    var currentHoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .creamyYellow
        return label
    }()
    
    var neededHoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .creamyYellow
        label.text = "/200"
        return label
    }()
    
    var changeButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitleColor(.eternalBlack, for: .normal)
        button.setTitleColor(.heavenlyWhite, for: .disabled)
        button.setBackgroundColor(color: .creamyYellow, forState: .normal)
        button.setBackgroundColor(color: .greyBackground, forState: .disabled)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitle("Change", for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        configureUI()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func configureUI() {
        self.backgroundColor = .stoneGrey
        self.layer.borderColor = UIColor.creamyYellow.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.addSubview(tittleLabel)
        self.addSubview(currentHoneyLabel)
        self.addSubview(neededHoneyLabel)
        self.addSubview(changeButton)

        tittleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        neededHoneyLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        currentHoneyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(neededHoneyLabel.snp.leading).offset(-2)
            make.top.equalToSuperview().offset(20)
        }
        changeButton.snp.makeConstraints { make in
            make.leading.equalTo(tittleLabel.snp.leading)
            make.trailing.equalTo(neededHoneyLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(33)
        }
        
        currentHoneyLabel.text = "0"
    }
    
}
