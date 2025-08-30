//
//  BaseViewModel.swift
//  Unsplash
//
//  Created by 금가경 on 8/29/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
