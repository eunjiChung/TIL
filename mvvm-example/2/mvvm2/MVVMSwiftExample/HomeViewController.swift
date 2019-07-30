//
//  HomeViewController.swift
//  MVVMSwiftExample
//
//  Created by Dino Bartosak on 25/09/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var gameLibrary: GameLibrary? {
        didSet {
            showGameScoreboardEditorViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showGameScoreboardEditorViewController()
    }
    
    // MARK: Private
    
    fileprivate func showGameScoreboardEditorViewController() {
        if !self.isViewLoaded {
            return
        }
        
        // 게임을 만드는 라이브러리에서 정보를 받아온다
        guard let gameLibrary = gameLibrary else {
            return
        }
        
        // 첫번째 게임 정보를 받아온다
        if let game = gameLibrary.allGames().first {
            
            let controller = UIStoryboard.loadGameScoreboardEditorViewController()
            
            // uncomment this when view model is implemented
            let viewModel = GameScoreboardEditorViewModelFromGame(withGame: game)
            controller.viewModel = viewModel
            
            self.insertChildController(controller, intoParentView: self.view)
        }
    }
}


