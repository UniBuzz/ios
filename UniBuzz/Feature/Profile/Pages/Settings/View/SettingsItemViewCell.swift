//
//  SettingsItemViewCell.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 05/10/22.
//

import SnapKit
import UIKit

class SettingsItemViewCell: UITableViewCell {
    // MARK: - Properties
    
    let tittleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .cloudSky
        label.numberOfLines = 3
        return label
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
        self.separatorInset = .zero
        self.backgroundColor = .midnights
        let stack = UIStackView(arrangedSubviews: [tittleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
        
    }

}
