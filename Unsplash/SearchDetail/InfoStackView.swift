//
//  InfoStackView.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import SnapKit
import UIKit

final class InfoStackView: UIStackView {
    private let sizeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .black)
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }

    init(title: String, data: String) {
        super.init(frame: .zero)
        
        configureData(title: title, data: data)
        setUpUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        axis = .horizontal
        distribution = .equalSpacing
        
        addArrangedSubview(sizeInfoLabel)
        addArrangedSubview(sizeLabel)
    }
    
    func configureData(title: String, data: String) {
        sizeInfoLabel.text = title
        sizeLabel.text = data
    }
}
