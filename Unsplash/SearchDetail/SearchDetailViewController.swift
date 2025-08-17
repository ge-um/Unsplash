//
//  SearchDetailViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import SnapKit
import UIKit
import Kingfisher

final class SearchDetailViewController: UIViewController {
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let createdDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart.fill")

        button.configuration = config
        
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseForegroundColor = button.isSelected ? .systemBlue : .systemGray4
            button.configuration = config
        }
        
        return button
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .systemFont(ofSize: 18, weight: .black)
        return label
    }()
    
    private let sizeInfoLabel = InfoStackView()
    private let viewInfoLabel = InfoStackView()
    private let downloadInfoLabel = InfoStackView()
    
    private let infoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
//    let image: SearchResponse
    let viewModel: SearchDetailViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: SearchResponse) {
        viewModel = SearchDetailViewModel(image: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupNavigationBar()
        bindData()
        setViewDidLoadTrigger()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(line)
        
        horizontalStackView.addArrangedSubview(profileImage)
        
        verticalStackView.addArrangedSubview(userName)
        verticalStackView.addArrangedSubview(createdDate)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(likeButton)
        
        view.addSubview(horizontalStackView)
        
        view.addSubview(imageView)
        view.addSubview(infoTitleLabel)
        
        infoStackView.addArrangedSubview(sizeInfoLabel)
        infoStackView.addArrangedSubview(viewInfoLabel)
        infoStackView.addArrangedSubview(downloadInfoLabel)
        
        view.addSubview(infoStackView)
        
        line.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(12)
            make.height.equalTo(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.greaterThanOrEqualTo(240)
            make.leading.equalTo(infoTitleLabel.snp.trailing).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
        
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
    
    private func bindData() {
        viewModel.output.configureDataWithSearchResponse.bind { [weak self] image in
            guard let self = self, let image = image else { return }
            userName.text = image.user.name
            createdDate.text = image.postDate
            sizeInfoLabel.configureData(title: "크기", data: image.size)
            
            guard let profileImageURL = URL(string: image.user.profileImage.medium), let imageURL = URL(string: image.urls.raw) else { return }
            
            profileImage.kf.setImage(with: profileImageURL)
            imageView.kf.setImage(with: imageURL)
        }
        
        viewModel.output.statisticsResults.bind { [weak self] image in
            guard let self = self, let image = image else { return }
            
            self.viewInfoLabel.configureData(title: "조회수", data: image.formattedViews)
            self.downloadInfoLabel.configureData(title: "다운로드", data: image.formattedDownloads)
        }
    }
    
    private func setViewDidLoadTrigger() {
        viewModel.input.viewDidLoad.value = ()
    }
}
