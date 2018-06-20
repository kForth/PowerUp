//
//  _5406
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class _5406: Robot {
    
    init(name:String) {
        super.init(name: name, atlas_name: "5406")
        _max_vel = CGFloat(180)
        _max_turn_vel = CGFloat(9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getIntakePos() -> CGPoint {
        let width = sprite.size.width / 2 * sprite.xScale
        switch current_intake_state {
        case .CUBE, .NO_CUBE:
            return CGPoint(
                x: sprite.position.x + (width + 7) * cos(sprite.zRotation),
                y: sprite.position.y + (width + 7) * sin(sprite.zRotation)
            )
        case .CUBE_DOWN, .INTAKING, .NO_CUBE_DOWN:
            return CGPoint(
                x: sprite.position.x + (width + 12) * cos(sprite.zRotation),
                y: sprite.position.y + (width + 12) * sin(sprite.zRotation)
            )
        case .CUBE_UP, .NO_CUBE_UP:
            return CGPoint(
                x: sprite.position.x - (width + 10) * cos(sprite.zRotation),
                y: sprite.position.y - (width + 10) * sin(sprite.zRotation)
            )
        }
    }
}
