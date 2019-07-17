//
//  PlayerScoreboardMoveEditorViewModelFromPlayer.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation


class PlayerScoreboardMoveEditorViewModelFromPlayer: NSObject, PlayerScoreboardMoveEditorViewModel {
    
    fileprivate let player: Player
    fileprivate let game: Game
    
    var playerName: String
    
    var onePointMoveCount: String
    var twoPointMoveCount: String
    var assistMoveCount: String
    var reboundMoveCount: String
    var foulMoveCount: String
    
    func onePointMove() {
        makeMove(.onePoint)
    }
    
    func twoPointsMove() {
        makeMove(.twoPoints)
    }
    
    func assistMove() {
        makeMove(.assist)
    }
    
    func reboundMove() {
        makeMove(.rebound)
    }
    
    func foulMove() {
        makeMove(.foul)
    }
    
    // MARK: - Init
    // View Model 생성자에서는 Model을 받아와서 초기화해준다
    init(withGame game: Game, player: Player) {
        self.game = game
        self.player = player
        
        self.playerName = player.name
        self.onePointMoveCount = "\(game.playerMoveCount(for: player, move: .onePoint))"
        self.twoPointMoveCount = "\(game.playerMoveCount(for: player, move: .twoPoints))"
        self.assistMoveCount = "\(game.playerMoveCount(for: player, move: .assist))"
        self.reboundMoveCount = "\(game.playerMoveCount(for: player, move: .rebound))"
        self.foulMoveCount = "\(game.playerMoveCount(for: player, move: .foul))"
    }
    
    // MARK: - Private
    
    fileprivate func makeMove(_ move: PlayerInGameMove) {
        game.addPlayerMove(move, for: player)
        
        onePointMoveCount = "\(game.playerMoveCount(for: player, move: .onePoint))"
        twoPointMoveCount = "\(game.playerMoveCount(for: player, move: .twoPoints))"
        assistMoveCount = "\(game.playerMoveCount(for: player, move: .assist))"
        reboundMoveCount = "\(game.playerMoveCount(for: player, move: .rebound))"
        foulMoveCount = "\(game.playerMoveCount(for: player, move: .foul))"
    }
}
