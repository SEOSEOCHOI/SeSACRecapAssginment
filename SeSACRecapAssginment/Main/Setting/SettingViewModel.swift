//
//  SettingViewModel.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/26/24.
//

import Foundation
enum SettingOption: CaseIterable {
    case profile
    case setting
}

enum SettingList: String, CaseIterable {
    case notice = "공지사항"
    case help = "자주 묻는 질문"
    case qna = "1:1 문의"
    case notification = "알림 설정"
    case restart = "처음부터 시작하기"
}

class SettingViewModel {
    
    let settingList = SettingList.allCases
    
    var numberOfRowsInSection: Int {
        return settingList.count
    }
    
    init() {
    }
    
    private func validation(nickname: String) {
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> String {
        return settingList[indexPath.row].rawValue
    }
}

