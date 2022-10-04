//
//  ChooseUniversityViewCell.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 29/09/22.
//

import UIKit

class UniversityViewCell: UICollectionViewCell {
    
    static let identifier: String = "UniversityViewCell"
    
    var viewModel: RegistrationViewModel?
    
    private var universityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var universityName: UILabel = {
        let label = UILabel()
        label.text = "Universitas Indonesia"
        label.textColor = .heavenlyWhite
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCell() {
        contentView.addSubview(universityImage)
        universityImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        
        contentView.addSubview(universityName)
        universityName.snp.makeConstraints { make in
            make.top.equalTo(universityImage.snp.bottom).offset(15)
            make.leading.trailing.equalTo(contentView)
        }
                
    }
    
    func configureData(university: University) {
        universityName.text = university.name
        viewModel?.getUniversityImage(link: university.image, completion: { data in
            DispatchQueue.main.async {
                self.universityImage.image = UIImage(data: data)
            }
        })
    }
    
    func addUniversity(){
        universityName.text = "Add your university"
        universityImage.image = UIImage(named: "addUniversity")
    }
    
    
}
