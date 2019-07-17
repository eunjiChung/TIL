//
//  Dynamic.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

// View Model의 Dynamic한 변화를 감지하기 위한 클래스!!!!
// RxSwift와 비슷....?
// 하지만 여기서는 Swift Generic을 사용할 것
class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
