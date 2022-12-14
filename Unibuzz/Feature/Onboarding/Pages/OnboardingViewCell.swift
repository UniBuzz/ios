//
//  OnboardingViewCell.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 24/10/22.
//

import UIKit


class OnboardingViewCell: UICollectionViewCell {
    
    public static let identifier = "OnboardingCell"
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .creamyYellow
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .heavenlyWhite
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let stackview = UIStackView(arrangedSubviews: [headingLabel,descriptionLabel])
        stackview.axis = .vertical
        stackview.spacing = 15
        stackview.distribution = .fillProportionally
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(stackview.snp.top).offset(-10)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    func configureCell(image: String, heading: String, description: String) {
        imageView.image = UIImage(named: image)
        headingLabel.text = heading
        descriptionLabel.text = description
    }
    
    
    
    
}
