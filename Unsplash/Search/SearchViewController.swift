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
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        
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
            make.height.equalTo(44)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(colorCollectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
