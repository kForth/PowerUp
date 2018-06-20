//
//  Exchange.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Exchange{
    
    var node: SKSpriteNode
    var label_node: SKLabelNode
    var num_cubes = 0
    
    init(node: SKSpriteNode, label_node: SKLabelNode){
        self.node = node
        self.label_node = label_node
    }
    
    func updateLabel(){
        label_node.text = String(format: "%d", num_cubes)
    }
    
    func reset(){
        num_cubes = 0
        updateLabel()
    }
    
    func addCube(){
        num_cubes += 1
        updateLabel()
    }
    
    func takeCube() -> Bool{
        if num_cubes > 0{
            num_cubes -= 1
            updateLabel()
            return true
        }
        return false
    }
    
}

