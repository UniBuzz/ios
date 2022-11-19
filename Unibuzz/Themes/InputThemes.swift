//
//  InputThemes.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 23/09/22.
//
import UIKit
import SnapKit

class InputThemes {
    
    func inputContainerView(textfield: UITextField, title: String) -> UIView {
        
        lazy var view = UIView()
        lazy var inputLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .cloudSky
            return label
        }()
        
        lazy var backgroundBubble: UIView = {
            let bView = UIView()
            bView.backgroundColor = .stoneGrey
            bView.layer.cornerRadius = 6
            return bView
        }()
        
        view.addSubview(inputLabel)
        view.addSubview(backgroundBubble)
        view.addSubview(textfield)
        
        inputLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        
        backgroundBubble.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        textfield.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundBubble)
            make.left.equalTo(backgroundBubble.snp.left).offset(10)
            make.right.equalTo(backgroundBubble.snp.right).offset(-10)
        }
        return view
    }
    
    func textField(withPlaceholder placeholder:String) -> UITextField{
        let tf = UITextField()
        tf.textColor = .heavenlyWhite
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.cloudSky])
        tf.autocorrectionType = .no
        return tf
    }
    
    func attributtedButton(_ firstPart: String, _ secondPart:String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributtedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributtedTitle.append(NSAttributedString(string: secondPart, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.creamyYellow, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        
        button.setAttributedTitle(attributtedTitle, for: .normal)
        
        return button
    }
    
}
