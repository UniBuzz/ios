//
//  ChooseUniversityViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 29/09/22.
//

import UIKit


class ChooseUniversityView: UIView {
    
    //MARK: - Properties
    let collectionView: UICollectionView = {
        let cvFlow = UICollectionViewFlowLayout()
        cvFlow.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlow)
        cv.backgroundColor = .midnights
        cv.register(UniversityViewCell.self, forCellWithReuseIdentifier: UniversityViewCell.identifier)
        return cv
    }()
    
    var viewModel: RegistrationViewModel? {
        didSet{
            bindViewModel()
        }
    }
    
    var previousSelected : IndexPath?
    var currentSelected : Int?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        setUpCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func bindViewModel(){
        guard let viewModel = viewModel else { return }
        viewModel.getUniversityList()
        viewModel.updateUniversityView = {
            self.collectionView.reloadData()
        }
    }
    
}

extension ChooseUniversityView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.universityList.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversityViewCell.identifier, for: indexPath) as! UniversityViewCell
        if indexPath.row == viewModel?.universityList.count {
            cell.addUniversity()
            return cell
        } else {
            let university = viewModel?.universityList[indexPath.row]
            cell.viewModel = viewModel
            cell.configureData(university: university!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelected = indexPath.row
        if currentSelected == viewModel?.universityList.count {
            print("DEBUG: ")
            return
        }
        previousSelected = indexPath
        viewModel?.universitySelected = viewModel?.universityList[currentSelected ?? 0]
    }
    
    
    
    
    
}
