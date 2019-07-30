//
//  Dynamic.swift
//  MVVMSwiftExample
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 29/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    // 리스너 바인딩만
    // 얘는 언제 써...?
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    // 리스너 바인딩하고 void문 리턴까지? (callback?)
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
