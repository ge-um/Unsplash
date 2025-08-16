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
        var viewDidLoad: Observable<Void> = Observable(())
    }
    
    struct Output {
        var searchResults: Observable<[SearchResponse]?> = Observable(nil)
        var navigateToDetail: Observable<SearchResponse?> = Observable(nil)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.fetchSearchResults()
        }
        
        input.imageCellTapped.lazyBind { [weak self] selectedImage in
            guard let self = self else { return }
            self.output.navigateToDetail.value = selectedImage
        }
        
    }
    
    private func fetchSearchResults() {
        NetworkManager.shared.callRequest(api: .search(keyword: "바다", page: 1, orderedBy: .latest, color: .purple), type: [SearchResponse].self) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(let searchResponse):
                output.searchResults.value = searchResponse
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
