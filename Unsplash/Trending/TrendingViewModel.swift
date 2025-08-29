//
//  TrendingViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

final class TrendingViewModel {
    struct Input {
        var viewDidLoad: Observable<Topic?> = Observable(nil)
    }
    
    struct Output {
        var topicResponses: Observable<[Int: [TopicResponse]]> = Observable([:])
        var showAlert: Observable<String> = Observable("")
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoad.lazyBind { [weak self] topic in
            guard let self = self, let topic = topic else { return }
            self.fetchTopicResponse(for: topic)
        }
    }
    
    private func fetchTopicResponse(for topic: Topic) {
        NetworkManager.shared.callRequest(api: .topic(topicId: topic.topicId), type: [TopicResponse].self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                var current = self.output.topicResponses.value
                current[topic.rawValue] = response
                self.output.topicResponses.value = current
            case .failure(let error):
                self.output.showAlert.value = error.localizedDescription
            }
        }
    }
}
