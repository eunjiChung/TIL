//
//  PlayerScoreboardMoveEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

protocol PlayerScoreboardMoveEditorViewModel {
    var playerName: String { get }
    
    // 변경되는 프로퍼티들을 동적인 타입으로 바꿔준다
    // 얘는 var, 구현부는 let - 왜...? 왜 얘는 var?
    var onePointMoveCount: Dynamic<String> { get }
    var twoPointMoveCount: Dynamic<String> { get }
    var assistMoveCount: Dynamic<String> { get }
    var reboundMoveCount: Dynamic<String> { get }
    var foulMoveCount: Dynamic<String> { get }
    
    func onePointMove()
    func twoPointMove()
    func assistMove()
    func reboundMove()
    func foulMove()
}
