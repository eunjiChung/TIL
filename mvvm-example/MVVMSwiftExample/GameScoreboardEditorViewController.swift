//
//  GameScoreboardEditorViewController.swift
//  MVVMSwiftExample
//
//  Created by Dino Bartosak on 25/09/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

class GameScoreboardEditorViewController: UIViewController {
    
    @IBOutlet weak var homePlayer1View: PlayerScoreboardMoveEditorView!
    @IBOutlet weak var homePlayer2View: PlayerScoreboardMoveEditorView!
    @IBOutlet weak var homePlayer3View: PlayerScoreboardMoveEditorView!

    @IBOutlet weak var awayPlayer1View: PlayerScoreboardMoveEditorView!
    @IBOutlet weak var awayPlayer2View: PlayerScoreboardMoveEditorView!
    @IBOutlet weak var awayPlayer3View: PlayerScoreboardMoveEditorView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var viewModel : GameScoreboardEditorViewModel? {
        // set과 비슷하지만 willSet, didSet 사용가능 - 얘네를 두고 Observer라고 하기도 함..
        // didSet의 경우 viewModel이 변경된 직후 fillUI() 호출
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
    }
    
    // MARK: Button Action
    
    @IBAction func pauseButtonPress(_ sender: AnyObject) {
        viewModel?.togglePause()
    }
    
    // MARK: Private

    fileprivate func styleUI() {
        self.view.backgroundColor = UIColor.backgroundColor
        self.scoreLabel.textColor = UIColor.scoreColor
        self.homeTeamNameLabel.textColor = UIColor.textColor
        self.awayTeamNameLabel.textColor = UIColor.textColor
        self.timeLabel.textColor = UIColor.textColor
    }
    
    fileprivate func fillUI() {
        // 뷰가 로딩되지 않았으면 return
        if !isViewLoaded { return }
        
        // viewModel이 초기화되지 않아서 옵셔널 타입이었으므로
        // guard문을 써준다
        guard let viewModel = viewModel else { return }
        
        self.homeTeamNameLabel.text = viewModel.homeTeam
        self.awayTeamNameLabel.text = viewModel.awayTeam
        
        viewModel.time.bindAndFire { [unowned self] in self.timeLabel.text = $0 }
        viewModel.score.bindAndFire { [unowned self] in self.scoreLabel.text = $0 }
        
        // 만약 종료상태면 플레이어를 숨긴다
        viewModel.isFinished.bindAndFire { [unowned self] in
            if $0 {
                self.homePlayer1View.isHidden = true
                self.homePlayer2View.isHidden = true
                self.homePlayer3View.isHidden = true
                
                self.awayPlayer1View.isHidden = true
                self.awayPlayer2View.isHidden = true
                self.awayPlayer3View.isHidden = true
            }
        }
        
        // isPaused 값도 바꿔줘야 하니까 bindAndFire를 쓴다
        // 근데 얜 뭘 리턴하는거지...?
        // 근데 왜 bindAndFire를 쓰는거지...?
        viewModel.isPaused.bindAndFire { [unowned self] in
            let title = $0 ? "Start" : "Pause"
            self.pauseButton.setTitle(title, for: .normal)
        }
        
        homePlayer1View.viewModel = viewModel.homePlayers[0]
        homePlayer2View.viewModel = viewModel.homePlayers[1]
        homePlayer3View.viewModel = viewModel.homePlayers[2]
        
        awayPlayer1View.viewModel = viewModel.awayPlayers[0]
        awayPlayer2View.viewModel = viewModel.awayPlayers[1]
        awayPlayer3View.viewModel = viewModel.awayPlayers[2]
    }

}
