//
//  File.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/26/24.
//

import Foundation

class Observable<T> {
    private var clousre: ((T)->Void)?
    
    var value: T {
        didSet {
            clousre?(value)
        }
    }
    
    init(_ value: T) {
        print(value)
        self.value = value
    }
    
    func bind(_ clousre: @escaping (T) -> Void) {
        print(#function)
        clousre(value)
        self.clousre = clousre
    }
}
