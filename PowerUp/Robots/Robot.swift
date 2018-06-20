//
//  Robot.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Robot {
    var name: String
    var sprite: SKSpriteNode
    
    var atlas: SKTextureAtlas
    var atlas_name: String
    
    enum intake_state: String {
        case NO_CUBE = "No_Cube"
        case CUBE = "With_Cube"
        case NO_CUBE_DOWN = "Intake_Down"
        case INTAKING = "Intaking"
        case CUBE_DOWN = "With_Cube_Down"
        case NO_CUBE_UP = "Up"
        case CUBE_UP = "Up_With_Cube"
    }
    var current_intake_state = intake_state.NO_CUBE
    var intake_timeout = Double(0)
    var intake_timeout_duration = Double(0.5)
    var movement_timeout = Double(0)
    var movement_timeout_duration = Double(0)
    
    init(name:String, atlas_name: String){
        self.name = name
        self.atlas_name = atlas_name
        atlas = SKTextureAtlas(named: atlas_name)
        sprite = SKSpriteNode(imageNamed: "\(atlas_name)_No_Cube")
        sprite.texture = getTexture()
        sprite.setScale(0.6)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        sprite.physicsBody?.allowsRotation = true
        sprite.physicsBody?.mass = 60
        sprite.zPosition = 50
    }
    
    func getTexture() -> SKTexture {
        return atlas.textureNamed(getTextureString(state: current_intake_state))
    }
    
    func getTextureString(state: intake_state) -> String {
        return "\(atlas_name)_\(state.rawValue)"
    }
    
    var _has_cube = false
    var _max_vel: CGFloat?
    var _max_turn_vel: CGFloat?
    var is_reversed = false
    
    func reset(with_cube cube:Bool = false, at_pos pos:CGPoint = CGPoint(x: 0, y: 0), facing_angle angle:CGFloat = CGFloat(0)){
        sprite.position = pos
        sprite.zRotation = angle
        setIntakeState(state: cube ? intake_state.CUBE : intake_state.NO_CUBE)
        stop()
    }
    
    func reverse(reset: Bool = false){
        if !reset || is_reversed {
            is_reversed = !is_reversed
            stop()
            timeoutMovement(duration: 0.2)
            sprite.run(SKAction.rotate(byAngle: CGFloat(pi), duration: 0.2))
        }
    }
    
    func stop(){
        setVel(x: 0, y: 0)
        sprite.physicsBody?.angularVelocity = 0
    }
    
    func timeoutMovement(duration: Double){
        movement_timeout = CACurrentMediaTime()
        movement_timeout_duration = duration
        stop()
    }
    
    func setIntakeState(state: intake_state){
        current_intake_state = state
        sprite.texture = getTexture()
        switch current_intake_state {
        case .NO_CUBE:
            _has_cube = false
            break
        case .CUBE:
            _has_cube = true
            break
        case .NO_CUBE_DOWN:
            _has_cube = false
            break
        case .CUBE_DOWN:
            _has_cube = true
            break
        case .INTAKING:
            _has_cube = false
            break
        case .NO_CUBE_UP:
            _has_cube = false
            break
        case .CUBE_UP:
            _has_cube = true
            break
        }
        
        switch current_intake_state {
        case .CUBE_UP, .NO_CUBE_UP:
            collideWithScale(collide: true)
            break
        default:
            collideWithScale(collide: false)
            break
        }
//        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
//        sprite.physicsBody?.usesPreciseCollisionDetection = true
//        sprite.physicsBody?.allowsRotation = false
//        sprite.physicsBody?.mass = 60
    }
    
    func collideWithScale(collide:Bool){
        if(collide){
            for key in ["upper_scale", "lower_scale"] as [String] {
                let plat = sprite.parent?.childNode(withName: key)
                plat?.physicsBody?.collisionBitMask = 4294967295
                plat?.physicsBody?.categoryBitMask = 4294967295
            }
            sprite.zPosition = 50
        }
        else{
            for key in ["upper_scale", "lower_scale"] as [String] {
                let plat = sprite.parent?.childNode(withName: key)
                plat?.physicsBody?.collisionBitMask = 0
                plat?.physicsBody?.categoryBitMask = 0
            }
            sprite.zPosition = 39
        }
    }
    
    func setPos(pos:CGPoint){
        sprite.position = pos //CGPoint(x: -field.size.width / 2 + 20, y: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func vectorAngle(vector: CGPoint) -> CGFloat {
        return CGFloat(atan2(vector.y, vector.x))
    }
    
    func getIntakePos() -> CGPoint {
        return sprite.position
    }
    
    func setVel(x:CGFloat, y:CGFloat){
        sprite.physicsBody?.velocity = CGVector(dx: x, dy: y)
    }
    
    func up(scene: GameScene){
        if !(scene.scale?.upper_platform.node.contains(sprite.position))! && !(scene.scale?.lower_platform.node.contains(sprite.position))! {
            setIntakeState(state: _has_cube ? intake_state.CUBE_UP : intake_state.NO_CUBE_UP)
        }
    }
    
    func down(){
        setIntakeState(state: _has_cube ? intake_state.CUBE : intake_state.NO_CUBE)
    }
    
    func intake_begin(scene: GameScene){
        switch current_intake_state {
            case .CUBE_UP:
                for plat in scene.scales + scene.switches {
                    if plat.node.contains(getIntakePos()) &&
                        !plat.node.calculateAccumulatedFrame().contains(sprite.position) {
                        //                        !plat.node.contains(player.sprite) {
                        if !plat.gambleCube() {
                            _ = scene.addCube(pos: getIntakePos())
                        }
                        setIntakeState(state: .NO_CUBE_UP)
                        intake_timeout = CACurrentMediaTime()
                        return
                    }
                }
                let cube = scene.addCube(pos: getIntakePos())
                cube.physicsBody?.applyImpulse(CGVector(dx: 500 * cos(sprite.zRotation + CGFloat(pi)), dy: 500 * sin(sprite.zRotation)))
                setIntakeState(state: _5406.intake_state.NO_CUBE_UP)
                break
            case .CUBE:
                for plat in scene.switches {
                    if plat.node.contains(getIntakePos()) &&
                        !plat.node.calculateAccumulatedFrame().contains(sprite.position) {
                        //                        !plat.node.contains(player.sprite) {
                        if !plat.gambleCube() {
                            _ = scene.addCube(pos: getIntakePos())
                        }
                        setIntakeState(state: .NO_CUBE_DOWN)
                        intake_timeout = CACurrentMediaTime()
                        return
                    }
                }
                for ex in scene.exchanges {
                    if ex.node.contains(getIntakePos()) {
                        ex.addCube()
                        setIntakeState(state: .NO_CUBE_DOWN)
                        intake_timeout = CACurrentMediaTime()
                        return
                    }
                }
                setIntakeState(state: intake_state.NO_CUBE_DOWN)
                intake_timeout = CACurrentMediaTime()
                let cube = scene.addCube(pos: getIntakePos())
                cube.physicsBody?.applyImpulse(CGVector(dx: 400 * cos(sprite.zRotation), dy: 400 * sin(sprite.zRotation)))
                break
            case .NO_CUBE, .NO_CUBE_UP:
                if current_intake_state == Robot.intake_state.NO_CUBE_UP {
                    reverse(reset: true)
                }
                setIntakeState(state: intake_state.INTAKING)
                break
            default:
                break
        }
    }
    
    func intake_end(){
        switch(current_intake_state){
            case .CUBE_DOWN:
                setIntakeState(state: intake_state.CUBE)
                break
            case .NO_CUBE_DOWN, .INTAKING:
                setIntakeState(state: intake_state.NO_CUBE)
                break;
            default:
                break;
        }
    }
    
    
    func update(velocity:CGPoint, angle:CGFloat, game_state: GameScene.game_states, scene: GameScene){
        
        if game_state == GameScene.game_states.TELE {
            // Arcade Drive
//            let vel = velocity.y * _max_vel!
//            setVel(x: vel * cos(sprite.zRotation), y: vel * sin(sprite.zRotation))
//            sprite.physicsBody?.angularVelocity = -velocity.x * CGFloat(_max_turn_vel!)
            
            // Field Centric Drive
            if movement_timeout_duration <= 0 || CACurrentMediaTime() - movement_timeout > movement_timeout_duration {
                movement_timeout_duration = 0
                setVel(x: velocity.x * _max_vel!, y: velocity.y * _max_vel!)
                sprite.zRotation = angle + CGFloat(pi / 2) + (is_reversed ? CGFloat(pi) : 0)
            }
        }
        
        if game_state == GameScene.game_states.TELE || game_state == GameScene.game_states.AUTO {
            switch current_intake_state {
                case .CUBE, .NO_CUBE, .CUBE_UP, .NO_CUBE_UP:
                    break
                case .NO_CUBE_DOWN:
                    if(CACurrentMediaTime() - intake_timeout > intake_timeout_duration){
                        setIntakeState(state: .INTAKING)
                    }
                    break
                case .INTAKING:
                    for node in scene.children {
                        if node.name == "cube" && node.contains(getIntakePos()) {
                            let node = node as! SKSpriteNode
                            node.removeFromParent()
                            setIntakeState(state: .CUBE_DOWN)
                            return
                        }
                    }
                    break
                case .CUBE_DOWN:
                    for ex in scene.exchanges {
                        if ex.node.contains(getIntakePos()) {
                            ex.addCube()
                            setIntakeState(state: .NO_CUBE_DOWN)
                            intake_timeout = CACurrentMediaTime()
                            return
                        }
                    }
                    break
            }
        }
    }
    
}
