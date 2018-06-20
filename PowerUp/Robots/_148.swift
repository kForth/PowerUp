//
//  _148
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class _148: Robot {
    
    init(name:String) {
        super.init(name: name, atlas_name: "148")
        _max_vel = CGFloat(240)
        _max_turn_vel = CGFloat(10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getIntakePos() -> CGPoint {
        let offset = sprite.size.height / 2 * sprite.yScale
        switch current_intake_state {
        case .CUBE, .CUBE_UP:
            return CGPoint(
                x: sprite.position.x + (offset + 7) * cos(sprite.zRotation),
                y: sprite.position.y + (offset + 7) * sin(sprite.zRotation)
            )
        case .NO_CUBE, .NO_CUBE_UP:
            return CGPoint(
                x: sprite.position.x + (offset + 6) * cos(sprite.zRotation),
                y: sprite.position.y + (offset + 6) * sin(sprite.zRotation)
            )
        case .CUBE_DOWN, .INTAKING, .NO_CUBE_DOWN:
            return CGPoint(
                x: sprite.position.x + (offset + 6) * cos(sprite.zRotation),
                y: sprite.position.y + (offset + 6) * sin(sprite.zRotation)
            )
        }
    }
}
