//
//  ImageCellViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/18/25.
//

import Foundation

final class ImageCellViewModel {
    struct Input {
        var likeButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        var isLiked: Observable<Bool> = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.likeButtonTapped.lazyBind { [weak self] _ in
            guard let self = self else { return }
            self.output.isLiked.value.toggle()
        }
    }
}
