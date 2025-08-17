//
//  TopicHeaderView.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import SnapKit
import UIKit

final class TopicHeaderView: UITableViewHeaderFooterView, IsIdentifiable {
    private let profileButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        config.background.cornerRadius = 22
        config.background.strokeColor = .tintColor
        config.background.strokeWidth = 5
        config.background.backgroundColor = .systemGray4
        
        button.configuration = config
        return button
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "OUR TOPIC"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(profileButton)
        contentView.addSubview(title)
        
        profileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(12)
            make.leading.bottom.equalToSuperview().inset(12)
        }
    }
}
