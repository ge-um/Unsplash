//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

final class SearchViewModel {
    struct Input {
        var imageCellTapped: CustomObservable<Search?> = CustomObservable(nil)
        var keyword: CustomObservable<String?> = CustomObservable(nil)
        var order: CustomObservable<Order> = CustomObservable(.relevant)
        var color: CustomObservable<ImageColor?> = CustomObservable(nil)
    }
    
    struct Output {
        var searchResults: CustomObservable<[Search]?> = CustomObservable(nil)
        var navigateToDetail: CustomObservable<Search?> = CustomObservable(nil)
        var sortButtonTitle: CustomObservable<String> = CustomObservable("최신순")
        var errorMessage: CustomObservable<String?> = CustomObservable(nil)
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
    
    private func fetchSearchResults() {
        guard let keyword = input.keyword.value else { return }
        
        NetworkManager.shared.callRequest(api: .search(keyword: keyword, page: 1, orderedBy: input.order.value, color: input.color.value), type: SearchResponse.self) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(let searchResponse):
                output.searchResults.value = searchResponse.results
            case .failure(let failure):
                output.errorMessage.value = failure.localizedDescription
            }
        }
    }
}
