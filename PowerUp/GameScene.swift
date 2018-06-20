//
//  GameScene.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/16/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let pi = 3.14159
    
    var team_number = 0
    
    enum game_states :String {
        case PRE, AUTO, TELE, POST
    }
    
    var current_game_state = game_states.PRE
    
    var cube_starting_points = [CGPoint]()
    
    var red_score = Double(0)
    var blue_score = Double(0)
    
    var intake_button = Button(imageNamed: "button")
    var up_button = Button(imageNamed: "button_arrow")
    var down_button = Button(imageNamed: "button_arrow")
    var reverse_button = Button(imageNamed: "button_r")
    var joystick = AnalogJoystick(diameters: (substrate: 150, stick: 50), images: (substrate: UIImage(named: "dpad"), stick: UIImage(named: "button")))
    
    var field = SKSpriteNode()
    var switches = [Platform]()
    var scales = [Platform]()
    var portals = [Portal]()
    var exchanges = [Exchange]()
    var left_switch: Switch?
    var right_switch: Switch?
    var scale: Switch?
    var platform: SKSpriteNode?
    
    var player: Robot?
    
    var time_label: SKLabelNode?
    var game_state_label: SKLabelNode?
    var red_score_label: SKLabelNode?
    var blue_score_label: SKLabelNode?
    var seconds_left = Double(3)
    
    var test_point: SKSpriteNode?
    
    func addPlayer(robot_type: String){
        switch robot_type {
        case "254":
            player = _254(name: "player")
            break
        case "148":
            player = _148(name: "player")
            break
        case "5406":
            player = _5406(name: "player")
            break
        default:
            player = _5406(name: "player")
            break
        }
        player!.reset(at_pos: CGPoint(x: -field.size.width / 2 + 20, y: 40))
        addChild(player!.sprite)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.darkGray
        
        test_point = SKSpriteNode(imageNamed: "button")
        test_point!.setScale(0.05)
        test_point!.zPosition = 1000
        addChild(test_point!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0);
        
        intake_button.zPosition = 50
        intake_button.position = CGPoint(x: 295, y: -125)
        intake_button.setScale(1.0)
        intake_button.add_touch_begin_callback(callback: intake_touch_begin)
        intake_button.add_touch_ended_callback(callback: intake_touch_end)
        addChild(intake_button)
        
        up_button.zPosition = 50
        up_button.position = CGPoint(x: 195, y: -90)
        up_button.setScale(0.5)
        up_button.add_touch_begin_callback(callback: up_touch_begin)
        addChild(up_button)
        
        down_button.zPosition = 50
        down_button.position = CGPoint(x: 195, y: -160)
        down_button.setScale(0.5)
        down_button.zRotation = CGFloat(pi)
        down_button.add_touch_begin_callback(callback: down_touch_begin)
        addChild(down_button)
        
        reverse_button.zPosition = 50
        reverse_button.position = CGPoint(x: 300, y: -30)
        reverse_button.setScale(0.4)
        reverse_button.add_touch_begin_callback(callback: reverse_touch_begin)
        addChild(reverse_button)
        
        joystick.zPosition = 50
        joystick.position = CGPoint(x: -285, y: -125)
        joystick.add_touch_begin_callback(callback: joystick_begin_tracking)
        addChild(joystick)
        
        field = self.childNode(withName: "//field") as! SKSpriteNode
        
        for key in ["//right_upper_switch", "//right_lower_switch", "//left_upper_switch", "//left_lower_switch"]{
            switches.append(Platform(node: self.childNode(withName: key) as! SKSpriteNode));
        }
        
        for key in ["//upper_scale", "//lower_scale"]{
            scales.append(Platform(node: self.childNode(withName: key) as! SKSpriteNode));
        }
        
        let switch_upper_is_red = arc4random_uniform(2) == 0
        let scale_upper_is_red = arc4random_uniform(2) == 0
        
        right_switch = Switch(upper: switches[0], lower: switches[1], upper_is_red: switch_upper_is_red)
        left_switch = Switch(upper: switches[2], lower: switches[3], upper_is_red: switch_upper_is_red)
        scale = Switch(upper: scales[0], lower: scales[1], upper_is_red: scale_upper_is_red)
        
        if switch_upper_is_red {
            (self.childNode(withName: "//left_switch_background") as! SKSpriteNode).zRotation = CGFloat(pi)
            (self.childNode(withName: "//right_switch_background") as! SKSpriteNode).zRotation = CGFloat(pi)
        }
        if scale_upper_is_red {
            (self.childNode(withName: "//scale_background") as! SKSpriteNode).zRotation = CGFloat(pi)
        }
        
        for key in ["//left_upper_portal", "//right_upper_portal", "//left_lower_portal", "//right_lower_portal"]{
            portals.append(Portal(
                node:  self.childNode(withName: key) as! SKSpriteNode ,
                label_node: self.childNode(withName: String(format: "%@_label", key)) as! SKLabelNode
            ));
        }
        
        for key in ["//left_exchange", "//right_exchange"]{
            exchanges.append(Exchange(
                node: self.childNode(withName: key) as! SKSpriteNode,
                label_node: self.childNode(withName: String(format: "%@_label", key)) as! SKLabelNode
            ));
        }
        
        platform = self.childNode(withName: "platform") as? SKSpriteNode
        
        for node in children {
            if node.name == "cube" {
                cube_starting_points.append(node.position)
            }
        }
    
        time_label = self.childNode(withName: "time_label") as? SKLabelNode
        game_state_label = self.childNode(withName: "game_state_label") as? SKLabelNode
        red_score_label = self.childNode(withName: "red_score_label") as? SKLabelNode
        blue_score_label = self.childNode(withName: "blue_score_label") as? SKLabelNode
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTime)), userInfo: nil, repeats: true)
    }
    
    func resetScene(){
        player?.reset(at_pos: CGPoint(x: -field.size.width / 2 + 20, y: 40))
        
        destroyCubes()
        for pnt in cube_starting_points {
            _ = addCube(pos: pnt)
        }
        for portal in portals {
            portal.reset()
        }
        for platform in switches {
            platform.reset()
        }
        for platform in scales {
            platform.reset()
        }
        for ex in exchanges {
            ex.reset()
        }
        
        red_score = 0
        blue_score = 0
        
        let switch_upper_is_red = arc4random_uniform(2) == 0
        let scale_upper_is_red = arc4random_uniform(2) == 0
        right_switch?.upper_is_red = switch_upper_is_red
        left_switch?.upper_is_red = switch_upper_is_red
        scale?.upper_is_red = scale_upper_is_red
        if switch_upper_is_red{
            (self.childNode(withName: "//left_switch_background") as! SKSpriteNode).zRotation = 3.14159
            (self.childNode(withName: "//right_switch_background") as! SKSpriteNode).zRotation = 3.14159
        }
    }
    
    @objc func updateTime() -> Void{
        if(seconds_left <= 0){
            switch(current_game_state){
            case .PRE:
                game_state_label?.text = "Auto"
                current_game_state = .AUTO
                seconds_left = 0
                player?.stop()
                break;
            case .AUTO:
                game_state_label?.text = "Tele"
                current_game_state = .TELE
                seconds_left = 135
                break;
            case .TELE:
                if (platform?.calculateAccumulatedFrame().contains(player!.sprite.position))! {
                    red_score += 5
                }
                game_state_label?.text = "Post Match"
                current_game_state = .POST
                seconds_left = 5
                player?.stop()
                break;
            case .POST:
                current_game_state = .PRE
                game_state_label?.text = "Pre-Match"
                seconds_left = 3
                resetScene()
                break;
            }
        }
        else{
            seconds_left -= 1
        }
        time_label?.text = "\(Int(floor(seconds_left)))"
        
        if(current_game_state == game_states.TELE || current_game_state == game_states.AUTO){
            let bonus = (current_game_state == game_states.AUTO) ? 2.0 : 1.0
            if (left_switch?.ownedByRed())! {
                red_score += 1 * bonus
            }
            
            if (right_switch?.ownedByBlue())! {
                blue_score += 1 * bonus
            }
            
            if (scale?.ownedByRed())! {
                red_score += 2 * bonus
            }
            else if (scale?.ownedByBlue())! {
                blue_score += 2 * bonus
            }
        }
        
        red_score_label?.text = "\(Int(floor(red_score)))"
        blue_score_label?.text = "\(Int(floor(blue_score)))"
    }
    
    func reverse_touch_begin() {
        if current_game_state == game_states.TELE {
            player?.reverse()
//            player.sprite.zRotation += CGFloat(pi)
        }
    }
    func down_touch_begin() {
        if current_game_state == game_states.TELE {
            player?.down()
        }
    }
    func up_touch_begin() {
        if current_game_state == game_states.TELE {
            player?.up(scene: self)
        }
    }
    func intake_touch_begin(){
        if current_game_state == game_states.TELE {
            player?.intake_begin(scene: self)
        }
    }
    func intake_touch_end(){
        if current_game_state == game_states.TELE {
            player?.intake_end()
        }
    }
    
    func joystick_begin_tracking(){
        player?.reverse(reset: true)
    }
    
    func handle_button_event(point pos : CGPoint){
        let dist = getDist(intake_button.position, pos)
        if dist < intake_button.size.width / 2 && current_game_state == game_states.TELE{
            
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
    
    override func update(_ currentTime: TimeInterval) {
        test_point?.position = player!.getIntakePos()
        let velocity = joystick.data.velocity
        let angle = joystick.data.angular
        if !joystick.isTracking() {
            player?.sprite.physicsBody?.angularVelocity = 0
        }
        player?.update(velocity: velocity, angle: angle, game_state: current_game_state, scene: self)
    }
    
    func addCube(pos:CGPoint) -> Cube{
        let new_cube = Cube(pos:pos)
        addChild(new_cube)
        return new_cube
    }
    
    func destroyCubes(){
        for node in children {
            if node.name == "cube" {
                node.removeFromParent()
            }
        }
    }
}
