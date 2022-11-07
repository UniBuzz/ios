//
//  ButtonThemes.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 03/10/22.
//

import UIKit
import SnapKit


class ButtonThemes: UIButton {
    
    
    init(buttonTitle: String) {
        super.init(frame: .zero)
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.eternalBlack, for: .normal)
        backgroundColor = .creamyYellow
        layer.cornerRadius = 25
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
