//
//  MbtiButtonView.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/12/25.
//

import SnapKit
import UIKit

final class MbtiButtonView: UIStackView {
    let title1: String
    let title2: String
    
    init(title1: String, title2: String) {
        self.title1 = title1
        self.title2 = title2
        
        super.init(frame: .zero)
        
        distribution = .fillEqually
        spacing = 12
        axis = .vertical
        
        addArrangedSubview(btn1)
        addArrangedSubview(btn2)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedTitle: String?
    
    lazy var btn1: UIButton = createMbtiButton(title: title1, tag: 1)
    lazy var btn2: UIButton = createMbtiButton(title: title2, tag: 2)
    
    private func createMbtiButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag

        var config = UIButton.Configuration.borderedTinted()
        config.attributedTitle = AttributedString(title, attributes: .init([.font: UIFont.systemFont(ofSize: 20, weight: .light)]))
        config.background.cornerRadius = 27
        config.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = config
        
        button.configurationUpdateHandler = {
            var config = button.configuration
            config?.baseBackgroundColor = $0.isSelected ? .C_1: .white
            config?.baseForegroundColor = $0.isSelected ? .white: .C_2
            config?.background.strokeColor = $0.isSelected ? .clear : .C_2
            button.configuration = config
        }
        return button
    }
}


