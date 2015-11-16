//
//  Planetoid.swift
//  PlanetaryDemo
//
//  Created by Jacob Martin on 11/12/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit
//import simd

// 🌏 planet node with simplex noise displacement geometry

class Planetoid: SCNNode {
    
    
    /**
     Creates a new planet node with displaced by simplex noise.
     
     - Parameters:
     - radius: radius of shpere before displacement
     - elevation: elevation of noise (amplitude)
     - seaLevel: the sea level... isnt imlemented at the moment. need to figure out the face overlap jitter problem
     - segmentCount: segment count of the sphere... in this case logarithmic because it is a geosphere
     
     - Returns: SCNNode containing the layers of a planet along with material
     
     */

    class func planetWithParameters(radius:CGFloat, elevation:CGFloat, seaLevel:CGFloat, segmentCount:Int) -> SCNNode {
       
        var node = SCNNode()  //this node will hold all the parts of the planet
        
        let sphereGeometry = geoSphere(radius, segmentCount: segmentCount, amplitude: elevation, floor: seaLevel, octaves: 10, frequency: 10.0 )
        let seaLevelGeometry = SCNSphere(radius: radius+seaLevel)
        let atmosphereGeometry = SCNSphere(radius: radius+elevation)

        
        seaLevelGeometry.segmentCount = segmentCount            //for now the atmosphere and sea components need to at the same
        atmosphereGeometry.segmentCount = segmentCount          //subdivision level as the terrain or else it looks odd
                                                                //need to find another way though or i'm drawing with too many polys
        
        
        let mat:SCNMaterial = sphereGeometry.firstMaterial!
        let mat2:SCNMaterial = SCNMaterial()
        let mat3:SCNMaterial = SCNMaterial()
//        mat.diffuse.contents = UIColor.brownColor()
     //    mat.diffuse.contents = UIImage(named: "1752-diagonal-stripes-2880x1800-abstract-wallpaper")
        mat3.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        mat3.ambient.contents = UIColor(red: 1.0, green: 0.7, blue: 1.0, alpha: 1.0)
       
                let bundle = NSBundle.mainBundle()
                let surfacePath = bundle.pathForResource("heightmap", ofType: "shader")
//                let geometryPath = bundle.pathForResource("NoiseBasis", ofType: "shader")
//                let lightingPath = bundle.pathForResource("toon", ofType: "shader")
        
        
                //reading
                do {
                    let text = try NSString(contentsOfFile: surfacePath!, encoding: NSUTF8StringEncoding)
                  //  let text2 = try NSString(contentsOfFile: lightingPath!, encoding: NSUTF8StringEncoding)
                    mat.shaderModifiers = [SCNShaderModifierEntryPointSurface : text as String]
                        
                                        //   SCNShaderModifierEntryPointLightingModel : text2 as String]
                                   }
                catch {
        
        
                }
        
        SCNTransaction.begin()
        
        
            mat.setValue(radius, forKey: "radius")
            mat.setValue(seaLevel, forKey: "seaLevel")
            mat.setValue(elevation, forKey: "elevation")
        
     
        
//        let data = NSData(bytes: perm, length: perm.count * sizeof(CInt))
//        mat.setValue(data, forKey: "perm")
        
        SCNTransaction.commit()
        
        seaLevelGeometry.materials = [mat2]
        atmosphereGeometry.materials = [mat3]
    
        
        seaLevelGeometry.firstMaterial!.diffuse.contents = UIColor(red: 0, green: 0, blue: 0.5, alpha: 1.0)
        
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(x: 0, y: 0, z: 0)
        node.addChildNode(sphereNode)
        
        let seaLevelNode = SCNNode(geometry: seaLevelGeometry)
        seaLevelNode.position = SCNVector3(x: 0, y: 0, z: 0)
        let atmosphereNode = SCNNode(geometry: atmosphereGeometry)
        atmosphereNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
    //    sphereNode.addChildNode(seaLevelNode)
        sphereNode.addChildNode(atmosphereNode)
        
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(SCNVector4: SCNVector4(x: Float(0), y: Float(1), z: Float(0), w: Float(M_PI)*2))
        animation.duration = 200
        
        animation.repeatCount = MAXFLOAT //repeat forever
        sphereNode.addAnimation(animation, forKey: nil)

        //...
        return node
    }
}