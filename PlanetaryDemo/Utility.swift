//
//  Utility.swift
//  PlanetaryDemo
//
//  Created by Jacob Martin on 11/12/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import QuartzCore

func norm3D(x:Float, y:Float, z:Float) -> Float{
    var s = sqrt(x * x + y * y + z * z)
    
    if(s==0){
        s=1
    }
    
    return s
    
}


