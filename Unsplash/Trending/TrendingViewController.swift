//
//  TrendingViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import SnapKit
import UIKit

final class TrendingViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
                
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TopicCell.self, forCellReuseIdentifier: TopicCell.identifier)
        
        return tableView
    }()
    
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
    
    private let viewModel = TrendingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpUI()
        bindData()
        
        viewModel.input.viewDidLoad.value = Topic(rawValue: 0)
    }
    
    private func setUpUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "OUR TOPIC"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    private func bindData() {
        viewModel.output.topicResponses.lazyBind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.output.showAlert.lazyBind { [weak self] message in
            self?.showAlert(title: "오류", message: message)
        }
    }
}
 
extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else { return UITableViewCell() }
        
        let topic = Topic(rawValue: indexPath.section)
        cell.configureData(section: indexPath.section)
        
        if let items = viewModel.output.topicResponses.value[indexPath.section] {
            cell.loadCollectionViewCell(items: items)
        }
        
        if viewModel.output.topicResponses.value[indexPath.section] == nil, let topic = topic {
            viewModel.input.viewDidLoad.value = topic
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}
