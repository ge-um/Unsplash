//
//  TrendingViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import SnapKit
import UIKit

final class TrendingViewController: UIViewController {
    private let headerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "OUR TOPIC"
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        config.background.cornerRadius = 22
        config.background.strokeColor = .tintColor
        config.background.strokeWidth = 3
        config.background.backgroundColor = .systemGray4
        button.configuration = config
        
        button.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        return button
    }()
    
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
    
    private let viewModel = TrendingViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindData()
    }
    
    private func bindData() {
        viewModel.input.viewDidLoad.value = ()

        viewModel.output.topicResponses.lazyBind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.output.showAlert.lazyBind { [weak self] message in
            self?.showAlert(title: "오류", message: message)
        }
    }
    
    @objc func navigate() {
        let vc = MbtiViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrendingViewController {
    private func setUpUI() {
        headerView.addSubview(titleLabel)
        headerView.addSubview(profileButton)
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.size.equalTo(32)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
 
extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else { return UITableViewCell() }
        
        cell.configureData(section: indexPath.section)
        
        if let items = viewModel.output.topicResponses.value[indexPath.section] {
            cell.loadCollectionViewCell(items: items)
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
