//
//  GameScoreboardEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 25/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

protocol GameScoreboardEditorViewModel {
    var homeTeam: String { get }
    var awayTeam: String { get }
    var time: Dynamic<String> { get }
    var score: Dynamic<String> { get }
    var isFinished: Dynamic<Bool> { get }
    
    var isPaused: Dynamic<Bool> { get }
    func togglePause()
    
    var homePlayers: [PlayerScoreboardMoveEditorViewModel] { get }
    var awayPlayers: [PlayerScoreboardMoveEditorViewModel] { get }
}

class GameScoreboardEditorViewModelFromGame: NSObject, GameScoreboardEditorViewModel {
    
    let game: Game
    
    struct Formatter {
        // 시간이 얼마나 남았는지, 아니면 원하는 다양한 시간 존속성을 표현하는 formatter
        static let durationFormatter: DateComponentsFormatter = {
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .positional
            return dateFormatter
        }()
    }
    
    // MARK: - GameScoreboardEditorViewModel protocol
    var homeTeam: String
    var awayTeam: String
    
    var time: Dynamic<String>
    var score: Dynamic<String>
    
    var isFinished: Dynamic<Bool>
    var isPaused: Dynamic<Bool>
    
    func togglePause() {
        
        if isPaused.value {
            startTimer()
        } else {
            pauseTimer()
        }
        
        self.isPaused.value = !isPaused.value
    }
    
    let homePlayers: [PlayerScoreboardMoveEditorViewModel]
    
    let awayPlayers: [PlayerScoreboardMoveEditorViewModel]
    
    
    // MARK: Init
    init(withGame game: Game) {
        self.game = game
        
        self.homeTeam = game.homeTeam.name
        self.awayTeam = game.awayTeam.name
        
        // init 안에서 method를 사용하려면 이렇게!
        self.time = Dynamic(GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: game))
        self.score = Dynamic(GameScoreboardEditorViewModelFromGame.scorePretty(for: game))
        self.isFinished = Dynamic(game.isFinished)
        self.isPaused = Dynamic(true)
        
        self.homePlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.homeTeam.players, game: game)
        self.awayPlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.awayTeam.players, game: game)
        
        // Score 올리는 Notification을 받는 메소드
        // 얘는 왜 아래에 추가...?
        super.init()
        subscribeToNotifications()
    }
    
    // Cleanup해주고 NotificationCenter에 의해 발생하는 error를 날려준다
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: Notifications (Private)
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameScoreDidChangeNotification(_:)), name: Notification.Name(GameNotifications.GameScoreDidChangeNotification), object: game)
    }
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func gameScoreDidChangeNotification(_ notification: Notification) {
        self.score.value = GameScoreboardEditorViewModelFromGame.scorePretty(for: game)
        
        if game.isFinished {
            self.isFinished.value = true
        }
    }
    
    // MARK: Private
    fileprivate static func playerViewModels(from players: [Player], game: Game) -> [PlayerScoreboardMoveEditorViewModel] {
        var playerViewModels = [PlayerScoreboardMoveEditorViewModel]()
        
        for player in players {
            playerViewModels.append(PlayerScoreboardMoveEditorViewModelFromPlayer(withGame: game, player: player))
        }
        
        return playerViewModels
    }
    
    fileprivate var gameTimer: Timer?
    
    fileprivate func startTimer() {
        let interval: TimeInterval = 0.001
        
        gameTimer = Timer.schedule(repeatInterval: interval, handler: { (timer) in
            self.game.time += interval
            self.time.value = GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: self.game)
        })
    }
    
    fileprivate func pauseTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    
    // MARK: String Utils
    fileprivate static func timeFormatted(totalMillis: Int) -> String {
        let millis: Int = totalMillis % 1000 / 100
        let totalSeconds: Int = totalMillis / 1000
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60)
        
        return String(format: "%02d:%02d.%d", minutes, seconds, millis)
    }
    
    fileprivate static func timeRemainingPretty(for game: Game) -> String {
        return timeFormatted(totalMillis: Int(game.time * 1000))
    }
    
    fileprivate static func scorePretty(for game: Game) -> String {
        return "\(game.homeTeamScore) - \(game.awayTeamScore)"
    }
    
    
    
}


























