//
//  Util.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

let pi = 3.14159

func getDist(_ p1:CGPoint, _ p2:CGPoint) -> CGFloat{
    return CGFloat(abs((pow(p2.x - p1.x, 2) + pow(p2.y - p1.y,2)).squareRoot()))
}
