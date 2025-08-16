//
//  SearchDetailViewController.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import UIKit

final class SearchDetailViewController: UIViewController {
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
        view.backgroundColor = .systemYellow
        navigationItem.title = image.user.name
    }
}
