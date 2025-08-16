//
//  SearchDetailViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import SnapKit
import UIKit

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
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "Brayden Prato"
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let createdDate: UILabel = {
        let label = UILabel()
        label.text = "2024년 7월 3일 게시됨"
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
    
    private let sizeInfoLabel = InfoLabel(sizeInfo: "크기", size: "3098 x 3872")
    private let viewInfoLabel = InfoLabel(sizeInfo: "조회수", size: "1,548,623")
    private let downloadInfoLabel = InfoLabel(sizeInfo: "다운로드", size: "388,996")
    
    private let infoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    let image: SearchResponse
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: SearchResponse) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupNavigationBar()
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
}
