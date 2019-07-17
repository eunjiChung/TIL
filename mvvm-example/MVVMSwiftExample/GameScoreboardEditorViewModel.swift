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
    var time: String { get }
    var score: String { get }
    var isFinished: Bool { get }
    
    var isPaused: Bool { get }
    func togglePause();
    
    // GameScoreboardEditorViewModel이 PlayerScoreboardMoveEditorViewModel의 parent이기 때문에
    // 참조 : HomeViewcontroller
    var homePlayers: [PlayerScoreboardMoveEditorViewModel] { get }
    var awayPlayers: [PlayerScoreboardMoveEditorViewModel] { get }
}

