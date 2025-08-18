//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

final class SearchViewModel {
    struct Input {
        var imageCellTapped: Observable<Search?> = Observable(nil)
        var searchButtonTapped: Observable<String?> = Observable(nil)
    }
    
    struct Output {
        var searchResults: Observable<[Search]?> = Observable(nil)
        var navigateToDetail: Observable<Search?> = Observable(nil)
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
        
        input.searchButtonTapped.lazyBind { [weak self] text in
            guard let self = self else { return }
            self.fetchSearchResults(text: text)
        }
    }
    
    // TODO: - 오류처리
    private func fetchSearchResults(text: String?) {
        guard let keyword = text else { return }
        
        NetworkManager.shared.callRequest(api: .search(keyword: keyword, page: 1, orderedBy: .relevant), type: SearchResponse.self) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(let searchResponse):
                output.searchResults.value = searchResponse.results
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
