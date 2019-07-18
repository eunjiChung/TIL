//
//  Dynamic.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 19/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

// MVVM 앱을 동적으로 만들기 위한 ViewModel
// Swift Generic과 closure를 이용해 구현
// 얘는 Model이 바뀌면, ViewModel의 프로퍼티가 감지하고
// 그 사실을 View에 전달한다!

// 근데 이게 왜 ViewModel일까?
// T = Placeholder 파라미터 = 타입 추론
class Dynamic<T> {
    // Closure를 위한 타입 정의 (내가 썼던거야~~)
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    // listener를 받았다는 건
    // closure를 수행하는 것 - completionHandler같은?
    // @escaping이 모야~~
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
    }
    
    // 얘는 value를 바꿔준다......
    func bindAndFire(_ listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    var value: T {
        // 바뀌는 걸 감지하기 위해서 필요..
        didSet {
            // 이 옵셔널은 뭘까....
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
}



























