//
//  Cube.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Cube: SKSpriteNode{
    init(pos:CGPoint){
        let texture = SKTexture(imageNamed: "cube")
        super.init(texture: texture, color: UIColor.black, size: texture.size())
//        super.init(imageNamed: "cube")
        self.setScale(0.22)
        self.position = pos
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 1
        self.physicsBody?.friction = 0.75
        self.physicsBody?.restitution = 0.7
        self.physicsBody?.linearDamping = 10
        self.physicsBody?.angularDamping = 0.75
        self.name = "cube"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
