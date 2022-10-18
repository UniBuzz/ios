//
//  PageControlView.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 03/10/22.
//

import UIKit


class PageControlView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let cvFlow = UICollectionViewFlowLayout()
        cvFlow.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlow)
        cv.backgroundColor = .midnights
        cv.register(CirclePageControl.self, forCellWithReuseIdentifier: CirclePageControl.identifier)
        cv.register(HorizontalLine.self, forCellWithReuseIdentifier: HorizontalLine.identifier)
        return cv
    }()
    
    var pageIndex: Int = 1
    var page: Int = 0
    
    init(page: Int) {
        super.init(frame: .zero)
        self.page = page
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
}


extension PageControlView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CirclePageControl.identifier, for: indexPath) as! CirclePageControl
            cell.configureCircle(visited: pageIndex <= page, page: pageIndex)
            pageIndex += 1
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalLine.identifier, for: indexPath) as! HorizontalLine
            return cell
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
    
    
    
    
}

class HorizontalLine: UICollectionViewCell {
    public static let identifier = "HorizontalLine"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = .midnights
        let horizontalLine: UIView = {
            let horizontal = UIView(frame: .zero)
            horizontal.backgroundColor = .cloudSky
            return horizontal
        }()
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        lineView.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(3)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

class CirclePageControl: UICollectionViewCell {
    
    public static let identifier = "CirclePageControl"
    
    private lazy var circleView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .eternalBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCircle(visited: Bool, page: Int){
        circleView.backgroundColor = visited ? .creamyYellow : .cloudSky
        
        contentView.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        circleView.layer.cornerRadius = 25
        circleView.layer.masksToBounds = true
        
        circleView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        label.text = String(page)
        label.textColor = .eternalBlack
        label.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
}
