//
//  TopicCell.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import SnapKit
import UIKit

enum Topic: Int, CaseIterable {
    case goldenHour
    case businessWork
    case architectureInterior
    
    var title: String {
        switch self {
        case .goldenHour:
            return "골든 아워"
        case .businessWork:
            return "비즈니스 및 업무"
        case .architectureInterior:
            return "건축 및 인테리어"
        }
    }
    
    var topicId: String {
        switch self {
        case .goldenHour:
            return "golden-hour"
        case .businessWork:
            return "business-work"
        case .architectureInterior:
            return "architecture-interior"
        }
    }
}

final class TopicCell: UITableViewCell, IsIdentifiable {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        layout.itemSize = .init(width: 200, height: 240)
        layout.sectionInset = .init(top: 12, left: 18, bottom: 12, right: 18)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopicImageCell.self, forCellWithReuseIdentifier: TopicImageCell.identifier)
        
        return collectionView
    }()
    
    private var items: [TopicResponse]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(section: Int) {
        titleLabel.text = Topic(rawValue: section)?.title
    }
    
    func loadCollectionViewCell(items: [TopicResponse]?) {
        self.items = items
        collectionView.reloadData()
    }
}

extension TopicCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicImageCell.identifier, for: indexPath) as? TopicImageCell else { return UICollectionViewCell() }
        
        cell.configure(item: items?[indexPath.row])
        
        return cell
    }
}
