//
//  ColorCell.swift
//  Unsplash
//
//  Created by 금가경 on 8/15/25.
//

import SnapKit
import UIKit

enum ImageColor: String, CaseIterable {
    case black, white, yellow, red, purple, green, blue

    var uiColor: UIColor {
        return switch self {
        case .black: .black
        case .white: .white
        case .yellow: .yellow
        case .red: .red
        case .purple: .purple
        case .green: .green
        case .blue: .blue
        }
    }
    
    var title: String {
        return switch self {
        case .black: "블랙"
        case .white: "화이트"
        case .yellow: "옐로우"
        case .red: "레드"
        case .purple: "퍼플"
        case .green: "그린"
        case .blue: "블루"
        }
    }
}

final class ColorCell: UICollectionViewCell, IsIdentifiable {
    
    let button: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "circlebadge.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))

        config.background.backgroundColor = .gray.withAlphaComponent(0.1)
        config.baseForegroundColor = .black
        config.background.cornerRadius = 24
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = config
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: ImageColor) {
        var config = button.configuration
        
        if let image = config?.image {
            let tinted = image.withTintColor(color.uiColor, renderingMode: .alwaysOriginal)
            config?.image = tinted
        }

        config?.title = color.title
        
        button.configuration = config
    }
}
