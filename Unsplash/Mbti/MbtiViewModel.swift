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
            .asDriver(onErrorJustReturn: "")
        
        let nicknameValidationColor = nicknameValidationResult
            .asDriver(onErrorJustReturn: false)
        
        let selectedEiButtonTag = Observable.merge(
            input.eButtonTapped.map { 1 },
            input.iButtonTapped.map { 2 }
        )
            .asDriver(onErrorJustReturn: 0)
        
        let selectedSnButtonTag = Observable.merge(
            input.sButtonTapped.map { 1 },
            input.nButtonTapped.map { 2 }
        )
            .asDriver(onErrorJustReturn: 0)
        
        let selectedTfButtonTag = Observable.merge(
            input.tButtonTapped.map { 1 },
            input.fButtonTapped.map { 2 }
        )
            .asDriver(onErrorJustReturn: 0)
        
        let selectedJpButtonTag = Observable.merge(
            input.jButtonTapped.map { 1 },
            input.pButtonTapped.map { 2 }
        )
            .asDriver(onErrorJustReturn: 0)
        
        let validationResult = Driver.combineLatest(
            nicknameValidationResult.asDriver(onErrorJustReturn: false),
            selectedEiButtonTag,
            selectedSnButtonTag,
            selectedTfButtonTag,
            selectedJpButtonTag
        )
            .map { isValidNickname, ei, sn, tf, jp in
                return isValidNickname && ei != 0 && sn != 0 && tf != 0 && jp != 0
            }
            .asDriver(onErrorJustReturn: false)
        
        let navigate = input.completeButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            nicknameValidationText: nicknameValidationText,
            nicknameValidationColor: nicknameValidationColor,
            selectedEiButtonTag: selectedEiButtonTag,
            selectedSnButtonTag: selectedSnButtonTag,
            selectedTfButtonTag: selectedTfButtonTag,
            selectedJpButtonTag: selectedJpButtonTag,
            validationResult: validationResult, navigate: navigate,
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

