//
//  GameScoreboardEditorViewModelFromGame.swift
//  MVVMSwiftExample
//
//  Created by CHUNGEUNJI on 18/07/2019.
//  Copyright © 2019 Toptal. All rights reserved.
//

import Foundation

class GameScoreboardEditorViewModelFromGame: NSObject, GameScoreboardEditorViewModel {
    
    // MARK: - Property
    let game: Game
    
    struct Formatter {
        static let durationFormatter: DateComponentsFormatter = {
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.unitsStyle = .positional
            return dateFormatter
        }()
    }
    
    // MARK: - GameScoreboardEditorViewModelFromGame Protocol
    var homeTeam: String
    var awayTeam: String
    let time: Dynamic<String>
    let score: Dynamic<String>
    let isFinished: Dynamic<Bool>
    
    let isPaused: Dynamic<Bool>
    func togglePause() {
        if isPaused.value {
            startTimer()    // Pause된 상태면 타이머 시작
        } else {
            stopTimer()     // Pause가 아니면 타이머가 돌아가고 있다는 뜻이므로 멈춘다
        }
        
        self.isPaused.value = !isPaused.value   // 현재 타이머 상태와 반대되는 것을 리턴
    }
    
    let homePlayers: [PlayerScoreboardMoveEditorViewModel]
    let awayPlayers: [PlayerScoreboardMoveEditorViewModel]
    
    // MARK: - Initialize
    init(withGame game: Game) {
        self.game = game
        
        self.homeTeam = game.homeTeam.name
        self.awayTeam = game.awayTeam.name
        
        // 얘네는 값을 바꾸거나, 받아오는 게 아니라
        // 초기화해주는거기 때문에
        // Dynamic 타입을 넣어주어야 함
        self.time = Dynamic(GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: game))
        self.score = Dynamic(GameScoreboardEditorViewModelFromGame.scorePretty(for: game))
        self.isFinished = Dynamic(game.isFinished)
        self.isPaused = Dynamic(true)
        
        self.homePlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.homeTeam.players, game: game)
        self.awayPlayers = GameScoreboardEditorViewModelFromGame.playerViewModels(from: game.awayTeam.players, game: game)
        
        // 얘는 왜 아래에 추가하지?
        super.init()
        subscribeToNotifications()
    }
    
    // 이건 왜...?
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Private
    fileprivate var gameTimer: Timer?
    
    // 얘는 왜 static이 아니지?
    // static : 처음 한번만 초기화된다...?
    fileprivate func startTimer() {
        let interval: TimeInterval = 0.001
        gameTimer = Timer.schedule(repeatInterval: interval, handler: { (timer) in
            self.game.time += interval
            self.time.value = GameScoreboardEditorViewModelFromGame.timeRemainingPretty(for: self.game)
        })
        
    }
    
    fileprivate func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    fileprivate static func playerViewModels(from players:[Player], game: Game) -> [PlayerScoreboardMoveEditorViewModel] {
        var playerViewModels = [PlayerScoreboardMoveEditorViewModel]()
        for player in players {
            // PlayerScoreboardMoveEditorViewModelFromPlayer 얘가 뷰모델을 상속받았으니까
            // 얘로 초기화해도 됨
            playerViewModels.append(PlayerScoreboardMoveEditorViewModelFromPlayer(withGame:game, player:player))
        }
        return playerViewModels
    }
    
    // MARK: - Notifications (Private)
    // 근데 얘는 왜 다이나믹으로 안해...? 얼마 안되서?
    fileprivate func subscribeToNotifications() {
        // ****NotificationCenter로 내가 스스로 observer가 되어 gameScoreDidChangeNotifications를 주시한다
        NotificationCenter.default.addObserver(self, selector: #selector(gameScoreDidChangeNotifications), name: Notification.Name(rawValue: GameNotifications.GameScoreDidChangeNotification), object: game)
    }
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // selector로 불리려면 @objc를 붙여야됨
    @objc fileprivate func gameScoreDidChangeNotifications(_ notification: Notification) {
        self.score.value = GameScoreboardEditorViewModelFromGame.scorePretty(for: game)
        
        if game.isFinished {
            self.isFinished.value = true
        }
    }
    
    // MARK: - String Utils
    // millisecond를 원하는 시간으로 formating
    fileprivate static func timeFormatted(totalMillis: Int) -> String {
        let millis: Int = totalMillis % 1000 / 100 // "/ 100" <- because we want only 1 digit
        let totalSeconds: Int = totalMillis / 1000
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60)
        
        return String(format: "%02d:%02d.%d", minutes, seconds, millis)
    }
    
    // 남은 시간 가공하여 리턴
    fileprivate static func timeRemainingPretty(for game:Game) -> String {
        return timeFormatted(totalMillis: Int(game.time * 1000))
    }
    
    // 스코어 표시 처리
    fileprivate static func scorePretty(for game:Game) -> String {
        return String(format: "\(game.homeTeamScore) - \(game.awayTeamScore)")
    }
}
