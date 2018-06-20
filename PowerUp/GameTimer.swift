//
//  GameTimer.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimer{
    
    var timer = Timer()
    
    let PRE_TIME = Double(10)
    let AUTO_TIME = Double(0)
    let TELE_TIME = Double(135)
    let POST_TIME = Double(0)
    
    enum GameState {
        case PRE, AUTO, TELE, POST
    }
    
    let time_label: SKLabelNode
    let game_state_label: SKLabelNode
    
    var game_state = GameState.PRE
    var seconds_left = Double(0)
    
    init(time_label: SKLabelNode, game_state_label: SKLabelNode){
        self.time_label = time_label
        self.game_state_label = game_state_label
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        start_pre_match()
    }
    
    @objc func updateTimer() {
        seconds_left -= 1
        if seconds_left < 0 {
            seconds_left = 0
        }
        time_label.text = "\(seconds_left)"
    }
    
    func start_pre_match(){
        game_state = GameState.PRE
        seconds_left = PRE_TIME
        game_state_label.text = "Pre-Match"
        time_label.text = "\(PRE_TIME)"
        Timer.scheduledTimer(timeInterval: PRE_TIME, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func start_auto(){
        game_state = GameState.AUTO
        seconds_left = AUTO_TIME
        game_state_label.text = "Auto"
        time_label.text = "\(AUTO_TIME)"
        Timer.scheduledTimer(timeInterval: AUTO_TIME, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func start_tele(){
        game_state = GameState.TELE
        seconds_left = TELE_TIME
        game_state_label.text = "Tele-Op"
        time_label.text = "\(TELE_TIME)"
        Timer.scheduledTimer(timeInterval: TELE_TIME, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func start_post_match(){
        game_state = GameState.POST
        seconds_left = POST_TIME
        game_state_label.text = "Post Match"
        time_label.text = "\(POST_TIME)"
    }
    
    
    
}
