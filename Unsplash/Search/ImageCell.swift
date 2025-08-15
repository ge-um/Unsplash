//
//  ImageCell.swift
//  Unsplash
//
//  Created by 금가경 on 8/15/25.
//

import SnapKit
import UIKit

final class ImageCell: UICollectionViewCell, IsIdentifiable {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "star.fill")
        
        return imageView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 8)))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        config.attributedTitle = .init("11111", attributes: .init([.font: UIFont.systemFont(ofSize: 12)]))
        config.imagePadding = 8
        config.background.backgroundColor = .darkGray
        config.cornerStyle = .capsule
        config.baseForegroundColor = .white
        
        button.configuration = config
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .white.withAlphaComponent(0.6)
        config.image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 15)))
        config.background.cornerRadius = 14

        button.configuration = config
        
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseForegroundColor = button.isSelected ? .systemBlue : .white
            button.configuration = config
        }
        
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .yellow
        
        contentView.addSubview(imageView)
        contentView.addSubview(starButton)
        contentView.addSubview(likeButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.size.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData() {
        
    }
    
    // TODO: - MVVM으로 바꾸기
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
    }
}
