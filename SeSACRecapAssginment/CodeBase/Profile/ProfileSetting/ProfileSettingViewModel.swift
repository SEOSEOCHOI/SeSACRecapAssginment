//
//  ProfileSettingViewModel.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/26/24.
//

import Foundation

enum ValidationError: Error {
    case isContainNumber
    case isLengthOver
    case iscontainSpecial
}

class ProfileSettingViewModel {
    var inputNickname = Observable("")
    
    var outputVlidation = Observable("")
    var outputValidationColor = Observable(false)
    
    init() {
        inputNickname.bind { value in
            self.validation(nickname: value)
        }
    }
    
    private func validation(nickname: String) {
        do {
            let _ = try validateUserInputError(text: nickname)
            outputVlidation.value =  "사용할 수 있는 닉네임이에요"
            outputValidationColor.value = true
        } catch {
            switch error {
            case ValidationError.isLengthOver:
                outputVlidation.value = "2글자 이상 10글자 미만으로 설정해 주세요"
                outputValidationColor.value = false
                
            case ValidationError.isContainNumber:
                outputVlidation.value = "닉네임에 숫자를 포함할 수 없어요."
                outputValidationColor.value = false

            case ValidationError.iscontainSpecial:
                outputVlidation.value = "닉네임에 @, #, $, %는 포함할 수 없어요."
                outputValidationColor.value = false

            default: break
            }
        }
    }
    
    private func validateUserInputError(text: String) throws -> Bool {
        let numberPattern: String = "^.*[0-9].*$"
        let specialPattern: String = "^.*[@#$%].*$"

        
        guard text.count >= 2, text.count < 10 else {
            throw ValidationError.isLengthOver
        }
        
        guard text.range(of: specialPattern, options: .regularExpression) == nil else {
            throw ValidationError.iscontainSpecial
        }
        
        guard text.range(of: numberPattern, options: .regularExpression) == nil else {
            throw ValidationError.isContainNumber
        }
    return true
    }
}
