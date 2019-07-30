//
//  PlayerScoreboardMoveEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 30/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

protocol PlayerScoreboardMoveEditorViewModel {
    var playerName: String { get }

    // 동적인 값들만 Dynamic으로 설정해준다
    var onePointMoveCount: Dynamic<String> { get }
    var twoPointMoveCount: Dynamic<String> { get }
    var assistMoveCount: Dynamic<String> { get }
    var reboundMoveCount: Dynamic<String> { get }
    var foulModeCount: Dynamic<String> { get }
    
    func onePointMove()
    func twoPointMove()
    func assistMove()
    func reboundMove()
    func foulMove()
}

class PlayerScoreboardMoveEditorViewModelFromPlayer : NSObject, PlayerScoreboardMoveEditorViewModel {
    
    fileprivate let player: Player
    fileprivate let game: Game
    
    // MARK: PlayerScoreboardMoveEditorViewModel Protocol
    let playerName: String
    
    var onePointMoveCount: Dynamic<String>
    var twoPointMoveCount: Dynamic<String>
    var assistMoveCount: Dynamic<String>
    var reboundMoveCount: Dynamic<String>
    var foulModeCount: Dynamic<String>
    
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
    
    
    // MARK: Init
    init(with game: Game, player: Player) {
        self.player = player
        self.game = game
        
        self.playerName = player.name
        self.onePointMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .onePoint))")
        self.twoPointMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .twoPoints))")
        self.assistMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .assist))")
        self.reboundMoveCount = Dynamic("\(game.playerMoveCount(for: player, move: .rebound))")
        self.foulModeCount = Dynamic("\(game.playerMoveCount(for: player, move: .foul))")
    }
    
    // MARK: Private
    fileprivate func makeMove(_ move: PlayerInGameMove) {
        game.addPlayerMove(move, for: player)
        
        // 얘네는 현재 Dynamic<T> 타입이므로 value를 가진다!
        // value를 직접 수정
        onePointMoveCount.value = "\(game.playerMoveCount(for: player, move: .onePoint))"
        twoPointMoveCount.value = "\(game.playerMoveCount(for: player, move: .twoPoints))"
        assistMoveCount.value = "\(game.playerMoveCount(for: player, move: .assist))"
        reboundMoveCount.value = "\(game.playerMoveCount(for: player, move: .rebound))"
        foulModeCount.value = "\(game.playerMoveCount(for: player, move: .foul))"
    }
    
}


































