//
//  DropOfHoneyView.swift
//  Unibuzz
//
//  Created by Muhammad Farhan Almasyhur on 01/11/22.
//

import UIKit

class DropOfHoneyView: UIView {
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "1 Drop of Honey!"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .creamyYellow
        label.textAlignment = .center
        return label
    }()
    private lazy var honeyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "honey")
        return image
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeay!\nYou verified your account"
        label.textColor = .heavenlyWhite
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var honeyInfo: UIView = {
        let info = UIView()
        info.backgroundColor = .stoneGrey
        info.layer.borderColor = UIColor.creamyYellow.cgColor
        info.layer.borderWidth = 1
        info.layer.cornerRadius = 20
        
        lazy var current = HoneyItemView(title: "Current Drops of Honey", honey: "1")
        lazy var total = HoneyItemView(title: "Total Drops of Honey", honey: "1")
        
        let stackH = UIStackView(arrangedSubviews: [
            current,
            total
        ])
        stackH.axis = .vertical
        stackH.spacing = 8
        info.addSubview(stackH)
        stackH.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        return info
    }()
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "Get your comments replied and waggled to earn more drops of honey. If you fill your honey pot, you can change your pseudoname, profile picture, and more!"
        label.textColor = .heavenlyWhite
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy var startButton: UIButton = {
        let button = ButtonThemes(buttonTitle: "Let's Start")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        addSubview(honeyImage)
        honeyImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headingLabel.snp.bottom).offset(20)
            make.width.equalTo(114)
            make.height.equalTo(136)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(honeyImage.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(honeyInfo)
        honeyInfo.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(70)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(honeyInfo.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
        
    }
    
}
