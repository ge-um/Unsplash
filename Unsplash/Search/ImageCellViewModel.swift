//
//  ImageCellViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/18/25.
//

import Foundation

final class ImageCellViewModel {
    struct Input {
        var likeButtonTapped: CustomObservable<Void> = CustomObservable(())
        var viewDidLoad: CustomObservable<Void> = CustomObservable(())
    }
    
    struct Output {
        var isLiked: CustomObservable<Bool> = CustomObservable(false)
    }
    
    var input: Input
    var output: Output
    
    var id: String?
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self = self, let id = id else { return }
            self.output.isLiked.value = UserDefaults.standard.bool(forKey: id)
        }
        
        input.likeButtonTapped.lazyBind { [weak self] _ in
            guard let self = self, let id = id else { return }
            self.toggleLikedImages(id: id)
            self.output.isLiked.value.toggle()
        }
    }
    
    private func toggleLikedImages(id: String) {
        let isLiked = UserDefaults.standard.bool(forKey: id)
        
        if isLiked == true {
            UserDefaults.standard.set(true, forKey: id)
        } else {
            UserDefaults.standard.removeObject(forKey: id)
        }
    }
}
