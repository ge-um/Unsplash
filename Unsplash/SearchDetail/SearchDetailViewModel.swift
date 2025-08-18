//
//  SearchDetailViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

class SearchDetailViewModel {
    struct Input {
        var viewDidLoad: Observable<Void> = Observable(())
    }
    
    struct Output {
        var configureDataWithSearchResponse: Observable<Search?> = Observable(nil)
        var statisticsResults: Observable<StatisticsResponse?> = Observable(nil)
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
    
    // TODO: - 에러 처리
    private func fetchStatisticsResults(imageId: String) {
        NetworkManager.shared.callRequest(api: .statistics(imageId: imageId), type: StatisticsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let statistics):
                self.output.statisticsResults.value = statistics
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
