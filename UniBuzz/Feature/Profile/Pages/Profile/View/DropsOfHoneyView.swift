//
//  DropsOfHoneyView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 06/10/22.
//

import UIKit
import SnapKit

class DropsOfHoneyView: UIView {
    
    //MARK: - Properties
    var tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .heavenlyWhite
        label.text = "Drops of Honey"
        return label
    }()
    
    var totalHoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .creamyYellow
        return label
    }()
    
    var chevronImage: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(systemName: "chevron.right")?.withTintColor(.creamyYellow, renderingMode: .alwaysOriginal)
        iv.image = image
        return iv
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
        self.backgroundColor = .midnights
        self.layer.borderColor = UIColor.creamyYellow.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.addSubview(tittleLabel)
        self.addSubview(totalHoneyLabel)
        self.addSubview(chevronImage)


        tittleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        chevronImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        totalHoneyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronImage.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        totalHoneyLabel.text = "70"
    }
    
}
