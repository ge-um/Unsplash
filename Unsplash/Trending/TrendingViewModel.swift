//
//  TrendingViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

final class TrendingViewModel {
    struct Input {
        var viewDidLoad: CustomObservable<Void> = CustomObservable(())
    }
    
    struct Output {
        var topicResponses: CustomObservable<[Int: [TopicResponse]]> = CustomObservable([:])
        var showAlert: CustomObservable<String> = CustomObservable("")
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoad.lazyBind { _ in
            self.fetchTopicResponse()
        }
    }
    
    private func fetchTopicResponse() {
        let dispatchGroup = DispatchGroup()
        var responses = [Int: [TopicResponse]]()

        for topic in Topic.allCases {
            dispatchGroup.enter()
            
            NetworkManager.shared.callRequest(api: .topic(topicId: topic.topicId), type: [TopicResponse].self) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    responses[topic.rawValue] = response
                case .failure(let error):
                    self.output.showAlert.value = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.output.topicResponses.value = responses
        }
    }
}
