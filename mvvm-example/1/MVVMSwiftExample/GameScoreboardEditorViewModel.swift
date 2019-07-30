//
//  GameScoreboardEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

protocol GameScoreboardEditorViewModel {
    var homeTeam: String { get }
    var awayTeam: String { get }
    
    // 그냥 무조건 동적인 건 전부 Dynamic으로...?
    var time: Dynamic<String> { get }
    var score: Dynamic<String> { get }
    var isFinished: Dynamic<Bool> { get }
    
    var isPaused: Dynamic<Bool> { get }
    func togglePause()
    
    // GameScoreboardEditorViewController가 PlayerScoreboardMovedEditorViewModel을 생성해야 하므로
    // 플레이어들을 가지고, Player ViewModel의 배열 타입을 가진다
    var homePlayers: [PlayerScoreboardMoveEditorViewModel] { get }
    var awayPlayers: [PlayerScoreboardMoveEditorViewModel] { get }
}
