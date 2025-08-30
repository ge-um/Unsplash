//
//  SearchDetailViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

class SearchDetailViewModel {
    struct Input {
        var viewDidLoad: CustomObservable<Void> = CustomObservable(())
    }
    
    struct Output {
        var configureDataWithSearchResponse: CustomObservable<Search?> = CustomObservable(nil)
        var statisticsResults: CustomObservable<StatisticsResponse?> = CustomObservable(nil)
        var errorMessage: CustomObservable<String?> = CustomObservable(nil)
    }
    
    var input: Input
    var output: Output
    
    let searchResponse: Search
        
    init(image: Search) {
        input = Input()
        output = Output()
        
        searchResponse = image
                
        input.viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            
            output.configureDataWithSearchResponse.value = image
            self.fetchStatisticsResults(imageId: image.id)
        }
    }
    
    private func fetchStatisticsResults(imageId: String) {
        NetworkManager.shared.callRequest(api: .statistics(imageId: imageId), type: StatisticsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let statistics):
                self.output.statisticsResults.value = statistics
            case .failure(let failure):
                self.output.errorMessage.value = failure.localizedDescription
            }
        }
    }
}
