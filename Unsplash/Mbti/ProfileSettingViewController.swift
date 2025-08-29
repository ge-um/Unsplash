//
//  ProfileSettingViewController.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/14/25.
//

import UIKit

final class ProfileSettingViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "PROFILE SETTING"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        if navigationController?.viewControllers.first !== self {
            var config = UIButton.Configuration.plain()
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0)
            config.baseForegroundColor = .black
            config.image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular))
            
            let backButton = UIButton(configuration: config)
            
            backButton.addAction(.init { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }, for: .touchUpInside)
            
            let barButton = UIBarButtonItem(customView: backButton)
            navigationItem.leftBarButtonItem = barButton
        }
    }
}
