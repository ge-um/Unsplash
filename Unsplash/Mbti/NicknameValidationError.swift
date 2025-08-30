//
//  NicknameValidationError.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/10/25.
//

import Foundation

enum NicknameValidationError: Error {
    case outOfRange
    case containsSpecialCharacter
    case containsNumber
}

extension NicknameValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .outOfRange: "2글자 이상 10글자 미만으로 설정해주세요"
        case .containsSpecialCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .containsNumber: "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}
