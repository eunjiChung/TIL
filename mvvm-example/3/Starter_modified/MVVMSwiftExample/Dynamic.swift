//
//  Dynamic.swift
//  MVVMSwiftExample
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 30/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    // listener가 없을 수도 있어서...?
    var listener: Listener?
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    // type은 임의의 타입 T
    // 프로퍼티가 설정되면 listener로 value를 넘겨준다?????
    var value: T {
        // Property Observer
        // 얘는 모지..?
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
}
