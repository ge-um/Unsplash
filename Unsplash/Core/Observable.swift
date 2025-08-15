//
//  Observable.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

final class Observable<T> {
    private var action: ((T) -> Void)?
    
    var value: T {
        didSet {
            action?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(action: @escaping (T) -> Void) {
        action(value)
        self.action = action
    }
    
    func lazyBind(action: @escaping (T) -> Void) {
        self.action = action
    }
}
