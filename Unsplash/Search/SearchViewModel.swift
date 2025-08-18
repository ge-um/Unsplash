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
        var keyword: Observable<String?> = Observable(nil)
        var order: Observable<Order> = Observable(.relevant)
        var color: Observable<ImageColor?> = Observable(nil)
    }
    
    struct Output {
        var searchResults: Observable<[Search]?> = Observable(nil)
        var navigateToDetail: Observable<Search?> = Observable(nil)
        var sortButtonTitle: Observable<String> = Observable("최신순")
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
        
        input.keyword.lazyBind { [weak self] keyword in
            guard let self = self else { return }
            self.fetchSearchResults()
        }

        input.order.bind { [weak self] order in
            guard let self = self else { return }
            self.fetchSearchResults()
            self.output.sortButtonTitle.value = order == .latest ? "관련순" : "최신순"
        }
        
        input.color.lazyBind { [weak self] order in
            guard let self = self else { return }
            self.fetchSearchResults()
        }
    }
    
    // TODO: - 오류처리
    private func fetchSearchResults() {
        guard let keyword = input.keyword.value else { return }
        
        NetworkManager.shared.callRequest(api: .search(keyword: keyword, page: 1, orderedBy: input.order.value, color: input.color.value), type: SearchResponse.self) { [weak self] response in
            
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
