//
//  MbtiViewModel.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/10/25.
//

final class MbtiViewModel {
    struct Input {
        var nickname: Observable<String?> = Observable(nil)
        var selectedButtonTitle: Observable<(ei: String?, sn: String?, tf: String?, jp: String?)> = Observable((nil, nil, nil, nil))
    }
    
    struct Output {
        var stateValidation: Observable<Bool> = Observable(false)
        var stateText: Observable<String?> = Observable(nil)
        var stateTextColor: Observable<Bool> = Observable(false)
        var mbtiValidation: Observable<Bool> = Observable(false)
        var isComplete: Observable<Bool> = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()

        input.nickname.bind { [unowned self] nickname in
            guard nickname != nil else {
                return
            }
            self.evaluateNicknameValidation()
        }
        
        input.selectedButtonTitle.lazyBind { [unowned self] (ei, sn, tf, jp) in
            self.evaluateMBTIValidation(ei, sn, tf, jp)
        }
        
        output.stateValidation.lazyBind { [unowned self] validation in
            self.evaluateComplete()
        }
        
        output.mbtiValidation.lazyBind { [unowned self] validation in
            self.evaluateComplete()
        }
    }
    
    private func validate() throws (NicknameValidationError) {
        guard let nickname = input.nickname.value else { throw .nil }
        
        guard (2..<10) ~= nickname.count else {
            throw .outOfRange
        }
        
        guard !nickname.contains(/[@#$%]/) else {
            throw .containsSpecialCharacter
        }
        
        guard nickname.allSatisfy ({ !$0.isNumber }) else {
            throw .containsNumber
        }
    }
    
    private func evaluateNicknameValidation() {
        do {
            try validate()
            output.stateText.value = "사용할 수 있는 닉네임이에요."
            output.stateTextColor.value = true
            output.stateValidation.value = true
        } catch {
            output.stateText.value = error.errorDescription
            output.stateTextColor.value = false
            output.stateValidation.value = false
        }
    }
    
    private func evaluateMBTIValidation(_ ei: String?, _ sn: String?, _ tf: String?, _ jp: String?) {
        output.mbtiValidation.value = ei != nil && sn != nil && tf != nil && jp != nil
    }
    
    private func evaluateComplete() {
        output.isComplete.value = output.mbtiValidation.value && output.stateValidation.value
    }
}

