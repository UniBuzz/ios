//
//  BeeBackgroundTableViewCell.swift
//  Unibuzz
//
//  Created by hada.muhammad on 25/10/22.
//

import UIKit
import SnapKit

class BeeBackgroundTableViewCell: UITableViewCell {
    
    private lazy var beeImageView: UIImageView = {
        let beeImage = UIImage(named: "mascot_dialogue_1")
        let beeImageView = UIImageView(image: beeImage)
        return beeImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.contentView.backgroundColor = .stoneGrey
    }
}
