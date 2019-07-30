//
//  GameScoreboardEditorViewModel.swift
//  MVVMSwiftExample
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 30/07/2019.
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
    
    // 근데 왜 Formatter를 굳이 struct로...?
    struct Formatter {
        // Computed Property
        static let durationFormatter: DateComponentsFormatter = {
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .positional
            return dateFormatter
        }()
    }
    
    // MARK: GameScoreboardEditorViewModel protocol
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
    
    // MARK: Initializer
    init(withGame game: Game) {
        self.game = game
        
        self.homeTeam = game.homeTeam.name
        self.awayTeam = game.awayTeam.name
        
        self.time = Dynamic(GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: game))
        self.score = Dynamic(GameScoreboardEditorViewModelFromGame.scorePretty(for: game))
        self.isFinished = Dynamic(game.isFinished)
        self.isPaused = Dynamic(true) // 처음 시작은 pause된 상태니까..
        
        self.homePlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.homeTeam.players, game: game)
        self.awayPlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.awayTeam.players, game: game)
        
        super.init() // 왜 이걸하지...?
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: Private
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameScoreDidChangeNotification(_:)), name: Notification.Name(GameNotifications.GameScoreDidChangeNotification), object: game)
    }
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func gameScoreDidChangeNotification(_ notification: Notification) {
        score.value = GameScoreboardEditorViewModelFromGame.scorePretty(for: game)
        
        if game.isFinished {
            self.isFinished.value = true
        }
    }
    
    fileprivate var gameTimer: Timer?
    fileprivate func startTimer() {
        let interval: TimeInterval = 0.001  // 몇초가 흐를지 정하는 것
        gameTimer = Timer.schedule(repeatInterval: interval, handler: { (timer) in
            self.game.time += interval
            // time 값을 고치는 것이니까 직접 value에 넣는다!!!
            self.time.value = GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: self.game)
        })
    }
    
    fileprivate func pauseTimer() {
        gameTimer?.invalidate() // 타이머를 멈추고 다시는 시작하지 않도록 run loop에서 제거한다
        gameTimer = nil
    }
    
    fileprivate static func playerViewModels(from players: [Player], game: Game) -> [PlayerScoreboardMoveEditorViewModel] {
        var playerViewModels = [PlayerScoreboardMoveEditorViewModel]()
        
        for player in players {
            playerViewModels.append(PlayerScoreboardMoveEditorViewModelFromPlayer(with: game, player: player))
        }
        
        return playerViewModels
    }
    
    // MARK: String Utils
    // 타이머를 이쁘게 밖에 보여주는 methods
    
    // 타입 메소드 : func 앞에 static을 붙인다, class를 붙이기도 한다(클래스에서)
    // 오버라이딩 불가한 method?!
    fileprivate static func timeFormatted(totalMillis: Int) -> String {
        let millis: Int = totalMillis % 1000 / 100    // 소수점 1만 남기려고....
        let totalSeconds: Int = totalMillis / 1000
        let seconds: Int = totalSeconds % 60
        let minutes: Int = totalSeconds / 60
        return String(format: "%02d:%02d.%d", minutes, seconds, millis)
    }
    
    fileprivate static func timeRemainingPretty(for game:Game) -> String {
        return timeFormatted(totalMillis: Int(game.time * 1000))
    }
    
    fileprivate static func scorePretty(for game:Game) -> String {
        return "\(game.homeTeamScore) - \(game.awayTeamScore)"
    }
    
}

























