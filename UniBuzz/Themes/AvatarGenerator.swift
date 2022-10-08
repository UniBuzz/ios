//
//  AvatarGenerator.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 08/10/22.
//

import UIKit
import SnapKit

class AvatarGenerator: UIView {
    
    //MARK: - Properties
    var pseudoname: String? {
        didSet {
            if let pseudoname {
                if pseudoname.count > 2 {
                    nameLabel.text = String(Array(pseudoname)[0...1]).uppercased()
                }
            }
            
        }
    }
    
    lazy var nameLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.textColor = .eternalBlack
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    //MARK: - Lifecycle

    init(pseudoname: String, background: Int) {
        super.init(frame: .zero)
        configureUI()
        self.pseudoname = pseudoname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configureUI() {
        self.backgroundColor = .cyan
        
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}
