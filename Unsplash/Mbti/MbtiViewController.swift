//
//  MbtiViewController.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/10/25.
//

import SnapKit
import UIKit

final class MbtiViewController: UIViewController {
    private let navigationLine: UIView = {
        let view = UIView()
        view.backgroundColor = .C_2.withAlphaComponent(0.3)
        return view
    }()
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        
        let profileImage = Mbti.allCases.randomElement()?.profileImage ?? Mbti.enfp.rawValue
        imageView.image = UIImage(systemName: profileImage)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.C_1.cgColor
        imageView.layer.borderWidth = 5
        
        return imageView
    }()
    
    private lazy var nicknameTextField: UITextField = {
       let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [.foregroundColor: UIColor.C_2, .font: UIFont.systemFont(ofSize: 15)])
        textField.textColor = .black
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private let textFieldLine: UIView = {
        let view = UIView()
        view.backgroundColor = .C_2.withAlphaComponent(0.3)
        return view
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .C_3
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "완료"
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        button.configuration = config
        button.configurationUpdateHandler = { button in
            config.baseBackgroundColor = button.isEnabled ? .C_1 : .C_2
        }
        
        button.isEnabled = false
        
        return button
    }()
    
    private let mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let eiButtonView = MbtiButtonView(title1: "E", title2: "I", type: .ei)
    private let snButtonView = MbtiButtonView(title1: "S", title2: "N", type: .sn)
    private let tfButtonView = MbtiButtonView(title1: "T", title2: "F", type: .tf)
    private let jpButtonView = MbtiButtonView(title1: "J", title2: "P", type: .jp)
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let viewModel = MbtiViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpUI()
        setUpAction()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        nicknameTextField.text = nil
        viewModel.output.stateText.value = nil
        
        viewModel.input.selectedButtonTitle.value = (nil, nil, nil, nil)
        
        
        [eiButtonView, snButtonView, tfButtonView, jpButtonView].forEach { buttonView in
            buttonView.button1.isSelected = false
            buttonView.button2.isSelected = false
        }
    }
    
    private func setUpUI() {
        view.addSubview(navigationLine)
        view.addSubview(profileImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldLine)
        view.addSubview(completeButton)
        view.addSubview(stateLabel)
        view.addSubview(mbtiLabel)
        
        buttonStackView.addArrangedSubview(eiButtonView)
        buttonStackView.addArrangedSubview(snButtonView)
        buttonStackView.addArrangedSubview(tfButtonView)
        buttonStackView.addArrangedSubview(jpButtonView)
        
        view.addSubview(buttonStackView)
        
        navigationLine.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationLine.snp.bottom).offset(28)
            make.size.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        textFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldLine.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(28)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.greaterThanOrEqualTo(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(24)
            make.height.equalTo(54 * 2 + 12)
            make.width.equalTo(54 * 4 + 12 * 3)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
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
    
    private func setUpAction() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        eiButtonView.button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        eiButtonView.button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        snButtonView.button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        snButtonView.button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tfButtonView.button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tfButtonView.button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        jpButtonView.button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        jpButtonView.button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
    
    private func bindViewModel() {
        viewModel.output.stateText.bind { [unowned self] stateText in
            self.stateLabel.text = self.viewModel.output.stateText.value
        }
        
        viewModel.output.stateTextColor.bind { [unowned self] color in
            self.stateLabel.textColor = color ? .C_1 : .C_3
        }
        
        viewModel.output.mbtiValidation.bind { [unowned self] validation in
            self.completeButton.isEnabled = validation && viewModel.output.stateValidation.value
        }
        
        viewModel.output.stateValidation.bind { [unowned self] validation in
            self.completeButton.isEnabled = validation && viewModel.output.mbtiValidation.value
        }
    }
    
    @objc private func textFieldEditingChanged() {
        viewModel.input.nickname.value = nicknameTextField.text
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let mbtiButtonView = sender.superview as? MbtiButtonView else {
            return
        }

        mbtiButtonView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }
            button.isSelected = (sender == button)
        }
        
        mbtiButtonView.selectedTitle = sender.configuration?.title
        
        switch mbtiButtonView.type {
        case .ei:
            viewModel.input.selectedButtonTitle.value.ei = mbtiButtonView.selectedTitle
        case .sn:
            viewModel.input.selectedButtonTitle.value.sn = mbtiButtonView.selectedTitle
        case .tf:
            viewModel.input.selectedButtonTitle.value.tf = mbtiButtonView.selectedTitle
        case .jp:
            viewModel.input.selectedButtonTitle.value.jp = mbtiButtonView.selectedTitle
        }
    }
    
    @objc private func completeButtonTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
