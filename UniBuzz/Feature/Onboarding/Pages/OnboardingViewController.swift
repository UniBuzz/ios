//
//  OnboardingViewController.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 24/10/22.
//

import UIKit


class OnboardingViewController: UIViewController {
    
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let cvFlow = UICollectionViewFlowLayout()
        cvFlow.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlow)
        cv.backgroundColor = .midnights
        cv.register(OnboardingViewCell.self, forCellWithReuseIdentifier: OnboardingViewCell.identifier)
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = viewModel.slides.count
        return pc
    }()
    
    private lazy var nextButton: UIButton = {
        let button = ButtonThemes(buttonTitle: "Next")
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = OnboardingViewModel()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == viewModel.slides.count - 1 {
                nextButton.setTitle("Join", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        configureCollectionView()
        view.backgroundColor = .midnights
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(100)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-30)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Selector
    
    @objc func nextPage() {
        if currentPage == viewModel.slides.count - 1 {
            viewModel.saveToUserDefault()
            navigationController?.pushViewController(LoginViewController(), animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingViewCell.identifier, for: indexPath) as! OnboardingViewCell
        let slide = viewModel.slides[indexPath.row]
        cell.configureCell(image: slide.image, heading: slide.heading, description: slide.description)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    
}
