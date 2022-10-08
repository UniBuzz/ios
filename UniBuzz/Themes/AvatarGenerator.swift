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
    var bgColors = [
        UIColor.rgb(red: 255, green: 143, blue: 143),
        UIColor.rgb(red: 255, green: 193, blue: 143),
        UIColor.rgb(red: 255, green: 234, blue: 143),
        UIColor.rgb(red: 221, green: 255, blue: 143),
        UIColor.rgb(red: 143, green: 255, blue: 154),
        UIColor.rgb(red: 143, green: 255, blue: 253),
        UIColor.rgb(red: 143, green: 201, blue: 255),
        UIColor.rgb(red: 152, green: 143, blue: 255),
        UIColor.rgb(red: 218, green: 143, blue: 255),
        UIColor.rgb(red: 255, green: 143, blue: 210)
    ]
    
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
        self.backgroundColor = bgColors[background%10]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configureUI() {
        
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}
