//
//  Toggle.swift
//  Unibuzz
//
//  Created by hada.muhammad on 20/11/22.
//

import UIKit
import SnapKit

protocol ToggleDelegate: AnyObject {
    func changeSection(section: FeedSection)
}

class Toggle: UIView {
    
    private let cornerRadius: CGFloat = 18
    
    private lazy var newButton: UIButton = {
        let newButton = UIButton()
        newButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        newButton.setTitle("New", for: .normal)
        newButton.setTitleColor(.heavenlyWhite, for: .normal)
        newButton.setTitleColor(.midnights, for: .selected)
        newButton.setBackgroundColor(color: .greyBackground, forState: .normal)
        newButton.setBackgroundColor(color: .creamyYellow, forState: .selected)
        newButton.layer.cornerRadius = cornerRadius
        newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)
        newButton.isSelected = true
        return newButton
    }()
    
    private lazy var hotButton: UIButton = {
        let hotButton = UIButton()
        hotButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        hotButton.setTitle("Hot", for: .normal)
        hotButton.setTitleColor(.heavenlyWhite, for: .normal)
        hotButton.setTitleColor(.midnights, for: .selected)
        hotButton.setBackgroundColor(color: .greyBackground, forState: .normal)
        hotButton.setBackgroundColor(color: .creamyYellow, forState: .selected)
        hotButton.layer.cornerRadius = cornerRadius
        hotButton.addTarget(self, action: #selector(hotButtonTapped), for: .touchUpInside)
        return hotButton
    }()
    
    internal weak var delegate: ToggleDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .greyBackground
        self.layer.cornerRadius = cornerRadius
        
        addSubview(newButton)
        newButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(hotButton)
        hotButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func newButtonTapped() {
        resetButtonState()
        delegate?.changeSection(section: .new)
        newButton.isSelected.toggle()
    }
    
    @objc func hotButtonTapped() {
        resetButtonState()
        delegate?.changeSection(section: .hot)
        hotButton.isSelected.toggle()
    }
    
    private func resetButtonState() {
        newButton.isSelected = false
        hotButton.isSelected = false
    }
}
