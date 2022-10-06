//
//  LogoutViewCell.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 06/10/22.
//

import UIKit

class LogoutViewCell: UITableViewCell {
    // MARK: - Properties
    
    let tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .warningRed
        label.text = "Logout"
        return label
    }()
    
    let separator: UIView = {
        let strip = UIView()
        strip.backgroundColor = .heavenlyWhite
        return strip
    }()


    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configureUI() {
        selectionStyle = .none
        self.backgroundColor = .midnights
        addSubview(tittleLabel)
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        tittleLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
        }
        }
        
}


