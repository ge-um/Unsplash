//
//  SearchViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/14/25.
//

import SnapKit
import UIKit

enum SearchCollectionView: Int {
    case color
    case result
}

final class SearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "키워드 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
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
        collectionView.tag = SearchCollectionView.color.rawValue
                
        return collectionView
    }()
    
    private lazy var sortButton: UIButton = {
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
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        let deviceSize = view.frame.width
        layout.itemSize = CGSize(width: (deviceSize - 4) / 2, height: 240)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = SearchCollectionView.result.rawValue
        collectionView.isHidden = true

        return collectionView
    }()
    
    private let resultStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let viewModel = SearchViewModel()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindData()
    }
    
    private func setUpUI() {
        navigationItem.title = "SEARCH PHOTO"
        
        view.addSubview(searchBar)
        view.addSubview(colorCollectionView)
        view.addSubview(sortButton)
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
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(36)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        resultStackView.snp.makeConstraints { make in
            make.top.equalTo(colorCollectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindData() {
        viewModel.output.searchResults.lazyBind { [weak self] response in
            guard let self = self else { return }
            
            guard let response = response, !response.isEmpty else {
                resultLabel.text = "검색 결과가 없습니다."
                resultCollectionView.isHidden = true
                resultLabel.isHidden = false
                return
            }
            
            self.resultCollectionView.reloadData()
            resultCollectionView.isHidden = false
            resultLabel.isHidden = true
        }
        
        viewModel.output.navigateToDetail.lazyBind { [weak self] selectedImage in
            guard let self = self, let image = selectedImage else { return }
            
            let vc = SearchDetailViewController(image: image)
            navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.output.sortButtonTitle.bind { [weak self] title in
            guard let self = self else { return }
            sortButton.configuration?.attributedTitle = AttributedString(title, attributes: .init([.font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        }
    }
    
    @objc private func sortButtonTapped(sender: UIButton) {
        guard let title = sender.configuration?.title, let order = Order(rawValue: title) else { return }
        viewModel.input.order.value = order
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = SearchCollectionView(rawValue: collectionView.tag) else { return 0 }
        
        switch type {
        case .color:
            return ImageColor.allCases.count
        case .result:
            return viewModel.output.searchResults.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = SearchCollectionView(rawValue: collectionView.tag) else { return UICollectionViewCell() }
        
        switch type {
        case .color:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            cell.configure(with: ImageColor.allCases[indexPath.item])
            
            return cell

        case .result:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
            
            guard let searchResults = viewModel.output.searchResults.value else {
                return UICollectionViewCell()
            }
            cell.configureData(search: searchResults[indexPath.item])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == resultCollectionView {
            guard let searchResults = viewModel.output.searchResults.value else {
                return
            }
            viewModel.input.imageCellTapped.value = searchResults[indexPath.item]
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.keyword.value = searchBar.text
    }
}

