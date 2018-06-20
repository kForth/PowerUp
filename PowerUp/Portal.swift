//
//  Portal.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Portal{
    
    let label_node: SKLabelNode
    let node: SKSpriteNode
    var num_cubes = 7
    
    init(node: SKSpriteNode, label_node: SKLabelNode){
        self.node = node
        self.label_node = label_node
        updateLabel()
    }
    
    func reset(){
        num_cubes = 0
        updateLabel()
    }
    
    func getCubePoint() -> CGPoint {
        return CGPoint(
            x: node.position.x + (node.size.width / 2) * cos(node.zRotation),
            y: node.position.y + (node.size.width / 2) * sin(node.zRotation)
        )
    }
    
    func updateLabel(){
        label_node.text = String(format: "%d", num_cubes)
    }
    
    func takeCube() -> Bool{
        if num_cubes > 0 {
            num_cubes -= 1
            updateLabel()
            return true
        }
        return false
    }
    
}

