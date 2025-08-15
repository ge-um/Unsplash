//
//  SearchViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/14/25.
//

import SnapKit
import UIKit

final class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "키워드 검색"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 8, right: 92)
        layout.itemSize = .init(width: 100, height: 36)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
                
        return collectionView
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "list.bullet.indent", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
        
        config.attributedTitle = AttributedString("최신순", attributes: .init([.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        config.background.backgroundColor = .white
        config.baseForegroundColor = .black
        config.background.cornerRadius = 24
        config.buttonSize = .mini
        config.background.strokeColor = .systemGray5
        config.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 36)
        
        button.configuration = config
        
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private let resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    private let resultStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        navigationItem.title = "SEARCH PHOTO"
        
        view.addSubview(searchBar)
        view.addSubview(colorCollectionView)
        view.addSubview(orderButton)
        resultStackView.addArrangedSubview(resultLabel)
        resultStackView.addArrangedSubview(resultCollectionView)
        view.addSubview(resultStackView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        colorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        orderButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(36)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(colorCollectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        cell.configure(with: ImageColor.allCases[indexPath.item])
        
        return cell
    }
}
