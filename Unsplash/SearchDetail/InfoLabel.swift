//
//  InfoLabel.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import SnapKit
import UIKit

final class InfoLabel: UILabel {
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
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing        
        return stackView
    }()
    
    let sizeInfo: String
    let size: String
    
    init(sizeInfo: String, size: String) {
        self.sizeInfo = sizeInfo
        self.size = size
        super.init(frame: .zero)
        
        configureData()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        stackView.addArrangedSubview(sizeInfoLabel)
        stackView.addArrangedSubview(sizeLabel)
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureData() {
        sizeInfoLabel.text = sizeInfo
        sizeLabel.text = size
    }
}
