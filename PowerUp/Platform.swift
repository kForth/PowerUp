//
//  Platform.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/16/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Platform{
    
    var node: SKSpriteNode
    var num_cubes = 0
    
    init(node:SKSpriteNode){
        self.node = node
    }
    
    func reset(){
        num_cubes = 0
        node.texture = SKTexture(imageNamed: "platform")
        node.zRotation = 0
    }
    
    func addCube(){
        num_cubes += 1
        
        if(num_cubes <= 6){
            node.texture = SKTexture(imageNamed: String(format: "platform_%d_%d", num_cubes, arc4random_uniform(4)))
        }
        else if(num_cubes <= 8){
            node.texture = SKTexture(imageNamed: String(format: "platform_%d_%d", num_cubes, arc4random_uniform(2)))
        }
        else{
            node.texture = SKTexture(imageNamed: "platform_full")
        }
        node.zRotation = (arc4random_uniform(3) == 0) ? 3.14159 : 0
    }
    
    func gambleCube() -> Bool{
        if num_cubes > 6{
            if num_cubes <= 9 {
                if arc4random_uniform(15) == 0{
                    return false
                }
            }
            else if num_cubes <= 12 {
                if arc4random_uniform(10) == 0{
                    return false
                }
            }
            else if num_cubes < 16 {
                if arc4random_uniform(6) == 0{
                    return false
                }
            }
            else{
                if arc4random_uniform(2) == 0 {
                    return false
                }
            }
        }
        addCube()
        return true
    }
    
}
