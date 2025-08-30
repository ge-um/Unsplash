//
//  MbtiViewModel.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/10/25.
//

import RxCocoa
import RxSwift

final class MbtiViewModel: BaseViewModel {
    struct Input {
        let nickname: Observable<String>
        let eButtonTapped: Observable<Void>
        let iButtonTapped: Observable<Void>
        let sButtonTapped: Observable<Void>
        let nButtonTapped: Observable<Void>
        let tButtonTapped: Observable<Void>
        let fButtonTapped: Observable<Void>
        let jButtonTapped: Observable<Void>
        let pButtonTapped: Observable<Void>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let nicknameValidationText: Driver<String>
        let nicknameValidationColor: Driver<Bool>
        let selectedEiButtonTag: Driver<Int>
        let selectedSnButtonTag: Driver<Int>
        let selectedTfButtonTag: Driver<Int>
        let selectedJpButtonTag: Driver<Int>
        let validationResult: Driver<Bool>
        let navigate: Driver<Void>
    }

    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nicknameValidationResult = input.nickname
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMap { owner, nickname in
                owner.evaluateNicknameValidation(nickname: nickname)
            }
        
        let nicknameValidationText = nicknameValidationResult
            .map { isValid in
                isValid ? "사용할 수 있는 닉네임이에요." : "잘못된 닉네임입니다."
            }
        
        let nicknameValidationColor = nicknameValidationResult
        
        let selectedEiButtonTag = Observable.merge(
            input.eButtonTapped.map { 1 },
            input.iButtonTapped.map { 2 }
        )
        
        let selectedSnButtonTag = Observable.merge(
            input.sButtonTapped.map { 1 },
            input.nButtonTapped.map { 2 }
        )
        
        let selectedTfButtonTag = Observable.merge(
            input.tButtonTapped.map { 1 },
            input.fButtonTapped.map { 2 }
        )
        
        let selectedJpButtonTag = Observable.merge(
            input.jButtonTapped.map { 1 },
            input.pButtonTapped.map { 2 }
        )
        
        let validationResult = Observable.combineLatest(
            nicknameValidationResult,
            selectedEiButtonTag,
            selectedSnButtonTag,
            selectedTfButtonTag,
            selectedJpButtonTag
        )
            .map { isValidNickname, ei, sn, tf, jp in
                return isValidNickname && ei != 0 && sn != 0 && tf != 0 && jp != 0
            }
        
        let navigate = input.completeButtonTapped
            
        return Output(
            nicknameValidationText: nicknameValidationText.asDriver(onErrorJustReturn: ""),
            nicknameValidationColor: nicknameValidationColor.asDriver(onErrorJustReturn: false),
            selectedEiButtonTag: selectedEiButtonTag.asDriver(onErrorJustReturn: 0),
            selectedSnButtonTag: selectedSnButtonTag.asDriver(onErrorJustReturn: 0),
            selectedTfButtonTag: selectedTfButtonTag.asDriver(onErrorJustReturn: 0),
            selectedJpButtonTag: selectedJpButtonTag.asDriver(onErrorJustReturn: 0),
            validationResult: validationResult.asDriver(onErrorJustReturn: false),
            navigate: navigate.asDriver(onErrorJustReturn: ()),
        )
    }
        
    private func validate(nickname: String) throws (NicknameValidationError) {
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
    
    private func evaluateNicknameValidation(nickname: String) -> Observable<Bool> {
        Observable.create { [weak self] observer in
            do {
                try self?.validate(nickname: nickname)
                observer.onNext(true)
            } catch {
                observer.onNext(false)
            }
            return Disposables.create()
        }
    }
}

