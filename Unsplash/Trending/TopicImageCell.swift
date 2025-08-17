//
//  TopicImageCell.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import SnapKit
import UIKit

final class TopicImageCell: UICollectionViewCell, IsIdentifiable {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "star.fill")
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 8)))?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        config.attributedTitle = .init("1,234", attributes: .init([.font: UIFont.systemFont(ofSize: 12)]))

        config.imagePadding = 8
        config.background.backgroundColor = .darkGray
        config.cornerStyle = .capsule
        config.baseForegroundColor = .white
        
        button.configuration = config
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(imageView)
        contentView.addSubview(starButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        starButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
