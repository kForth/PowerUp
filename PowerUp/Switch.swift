//
//  File.swift
//  PowerUp
//
//  Created by Kestin Goforth on 6/17/18.
//  Copyright © 2018 Kestin Goforth. All rights reserved.
//

import Foundation
import SpriteKit

class Switch {
    
    let upper_platform: Platform
    let lower_platform: Platform
    var upper_is_red: Bool
    
    init(upper:Platform, lower:Platform, upper_is_red:Bool){
        self.upper_platform = upper
        self.lower_platform = lower
        self.upper_is_red = upper_is_red
    }
    
    func reset(){
        upper_platform.reset()
        lower_platform.reset()
    }
    
    func ownedByRed() -> Bool{
        if upper_is_red {
            return upper_platform.num_cubes > lower_platform.num_cubes
        }
        else{
            return upper_platform.num_cubes < lower_platform.num_cubes
        }
    }
    
    func ownedByBlue() -> Bool{
        if upper_is_red {
            return upper_platform.num_cubes < lower_platform.num_cubes
        }
        else{
            return upper_platform.num_cubes > lower_platform.num_cubes
        }
    }
    
}
