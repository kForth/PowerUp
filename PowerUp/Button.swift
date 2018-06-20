//
//  Button.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    
    var touched = false
    var last_touched = false
    
    var touch_begin_callbacks = [() -> ()]()
    var touch_moved_callbacks = [() -> ()]()
    var touch_ended_callbacks = [() -> ()]()
    
    init(imageNamed img:String){
        let texture = SKTexture(imageNamed: img)
        super.init(texture: texture, color: UIColor.black, size: texture.size())
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add_touch_begin_callback(callback: @escaping (() -> ())) {
        touch_begin_callbacks.append(callback)
    }
    func add_touch_moved_callback(callback: @escaping (() -> ())) {
        touch_moved_callbacks.append(callback)
    }
    func add_touch_ended_callback(callback: @escaping (() -> ())) {
        touch_ended_callbacks.append(callback)
    }
    
    func pointIsTouching(point:CGPoint, point2: CGPoint = CGPoint.zero) -> Bool {
        return getDist(point, point2) < ((self.texture?.size().width)! / 2)
    }
    
    func reset(){
        touched = false
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, pointIsTouching(point: touch.location(in: self as SKNode)) {
            touched = true
            for callback in touch_begin_callbacks {
                callback()
            }
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard touched else {
                return
            }
            if !pointIsTouching(point: touch.location(in: self as SKNode)) {
                touched = false
                for callback in touch_ended_callbacks {
                    callback()
                }
            }
            else{
                for callback in touch_moved_callbacks {
                    callback()
                }
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
        for callback in touch_ended_callbacks {
            callback()
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
        
}
