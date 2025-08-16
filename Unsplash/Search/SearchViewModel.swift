//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

final class SearchViewModel {
    struct Input {
        var imageCellTapped: Observable<SearchResponse?> = Observable(nil)
    }
    
    struct Output {
        var navigateToDetail: Observable<SearchResponse?> = Observable(nil)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.imageCellTapped.lazyBind { [weak self] selectedImage in
            guard let self = self else { return }
            self.output.navigateToDetail.value = selectedImage
        }
    }
}
