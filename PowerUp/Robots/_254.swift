//
//  _254.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class _254: Robot {
    
    init(name:String) {
        super.init(name: name, atlas_name: "254")
        _max_vel = CGFloat(240)
        _max_turn_vel = CGFloat(10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getIntakePos() -> CGPoint {
        let offset = sprite.size.height / 2 * sprite.yScale
        switch current_intake_state {
        case .CUBE, .NO_CUBE, .CUBE_UP, .NO_CUBE_UP:
            return CGPoint(
                x: sprite.position.x + (offset + 8) * cos(sprite.zRotation),
                y: sprite.position.y + (offset + 8) * sin(sprite.zRotation)
            )
        case .CUBE_DOWN, .INTAKING, .NO_CUBE_DOWN:
            return CGPoint(
                x: sprite.position.x + (offset + 7) * cos(sprite.zRotation),
                y: sprite.position.y + (offset + 7) * sin(sprite.zRotation)
            )
        }
    }
}
