//
//  UserDefaultManager.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/18/24.
//

import Foundation
// MARK: Singleton Pattern

class UserDefaultManager {
    private init() { }
    
    static let shaerd = UserDefaultManager()
    
    enum UDKey: String {
        case userImage
        case userNickname
        case userStatus
        case userSearch
        case userLike
    }
    
    let ud = UserDefaults.standard
    
    var userImage: String {
        get {            
            return ud.string(forKey: UDKey.userImage.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userImage.rawValue)
        }
    }

    var userNickname: String {
        get {
            return ud.string(forKey: UDKey.userNickname.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userNickname.rawValue)
        }
    }
    
    var userStatus: Bool {
        get {
            return ud.bool(forKey: UDKey.userStatus.rawValue)
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userStatus.rawValue)
        }
    }
    
    var userSearch: Array<String> {
        get {
            return ud.stringArray(forKey: UDKey.userSearch.rawValue)!
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userSearch.rawValue)
        }
    }
    

    var userLike: [String] {
        get {
            return ud.stringArray(forKey: UDKey.userLike.rawValue) ?? []
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userLike.rawValue)
        }
    }
    
}



