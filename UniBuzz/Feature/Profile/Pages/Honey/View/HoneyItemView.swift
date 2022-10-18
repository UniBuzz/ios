//
//  HoneyItemView.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 08/10/22.
//

import UIKit
import SnapKit

class HoneyItemView: UIView {

    //MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .heavenlyWhite
        return label
    }()
    
    let honeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .creamyYellow
        return label
    }()
    
    //MARK: - Lifecycle
    init(title: String,honey: String) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        honeyLabel.text = honey
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configureUI() {
        addSubview(titleLabel)
        addSubview(honeyLabel)
        
        titleLabel.snp.makeConstraints{ make in
            make.top.left.bottom.equalToSuperview()
        }
        honeyLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.right).offset(-50)
        }
    }

}
