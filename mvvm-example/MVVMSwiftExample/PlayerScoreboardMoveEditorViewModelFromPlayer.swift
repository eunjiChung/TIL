//
//  PlayerScoreboardMoveEditorViewModelFromPlayer.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation


class PlayerScoreboardMoveEditorViewModelFromPlayer : NSObject, PlayerScoreboardMoveEditorViewModel {
    
    // MARK: - Instance
    fileprivate let game: Game
    fileprivate let player: Player
    
    // MARK: - PlayerScoreboardMoveEditorViewModelFromPlayer Protocol
    var playerName: String
    
    let onePointMoveCount: Dynamic<String>
    let twoPointMoveCount: Dynamic<String>
    let assistMoveCount: Dynamic<String>
    let reboundMoveCount: Dynamic<String>
    let foulMoveCount: Dynamic<String>
    
    func onePointMove() {
        makeMove(.onePoint)
    }
    
    func twoPointMove() {
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
    
    // MARK: - Initialize
    init(withGame game:Game, player:Player) {
        self.game = game
        self.player = player
        
        self.playerName = player.name
        self.onePointMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .onePoint))")
        self.twoPointMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .twoPoints))")
        self.assistMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .assist))")
        self.reboundMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .rebound))")
        self.foulMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .foul))")
    }
    
    // MARK: - Private
    // PlayerInGameMove: Game에 있는 enum 타입 -> Global도 아닌데 어디에 선언하든 상관없는건가?
    fileprivate func makeMove(_ move: PlayerInGameMove) {
        game.addPlayerMove(move, for: player)
        
        // 프로퍼티들이 Dynamic 타입이고,
        // Dynamic 타입 안에 value가 있기 때문에
        // 프로퍼티들도 value를 쓸 수 있다....
        onePointMoveCount.value = "\(game.playerMoveCount(for: player, move: .onePoint))"
        twoPointMoveCount.value = "\(game.playerMoveCount(for: player, move: .twoPoints))"
        assistMoveCount.value = "\(game.playerMoveCount(for: player, move: .assist))"
        reboundMoveCount.value = "\(game.playerMoveCount(for: player, move: .rebound))"
        foulMoveCount.value = "\(game.playerMoveCount(for: player, move: .foul))"
    }
    
    
}
