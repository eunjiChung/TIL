//
//  PlayerScoreboardMoveEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

protocol PlayerScoreboardMoveEditorViewModel {
    // Instance와 수행될 method를 넣는다
    var playerName: String { get }
    
    var onePointMoveCount: String { get }
    var twoPointMoveCount: String { get }
    var assistMoveCount: String { get }
    var reboundMoveCount: String { get }
    var foulMoveCount: String { get }
    
    func onePointMove()
    func twoPointsMove()
    func assistMove()
    func reboundMove()
    func foulMove()
}
