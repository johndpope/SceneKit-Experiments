//
//  Primitives.swift
//  NoiseGeometry
//
//  Created by Jacob Martin on 11/3/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit
import QuartzCore


func toSpherical(x:Float, y:Float, z:Float) -> CGPoint{
    let norm:Float = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2))
    var point:CGPoint = CGPointMake(acos(CGFloat(z/norm)), atan(CGFloat(y/x)))
    if (point.y.isNaN){
        point.y = 0
    }
    if (point.x.isNaN){
        point.x = 0
    }
    
    return point
}



func geoSphere(radius:CGFloat, segmentCount:Int, amplitude:CGFloat, floor:CGFloat, octaves:Int, frequency:CGFloat) -> SCNGeometry{
    
    var sph:SCNSphere = SCNSphere(radius: radius)
    
    
    SCNTransaction.begin()
    sph.geodesic = true
    sph.segmentCount = segmentCount
    
    SCNTransaction.commit()
    
    let vertex_src = sph.geometrySourcesForSemantic(SCNGeometrySourceSemanticVertex)[0]    //pull out vertex data
    let normal_src = sph.geometrySourcesForSemantic(SCNGeometrySourceSemanticNormal)[0]    //and surface normal data
    let texture_src = sph.geometrySourcesForSemantic(SCNGeometrySourceSemanticTexcoord)[0] //as well as texture coordinate data so we may keep the same texture mapping
    
    let stride:NSInteger = vertex_src.dataStride; // in bytes
    let offset:NSInteger = vertex_src.dataOffset; // in bytes
    
    let componentsPerVector:NSInteger = vertex_src.componentsPerVector;
    let bytesPerVector:NSInteger = componentsPerVector * vertex_src.bytesPerComponent;
    let vectorCount:NSInteger = vertex_src.vectorCount;
    
    
    let count = vertex_src.data.length / sizeof(Float)
    
    var vertArray = [Float](count: count, repeatedValue: 0)
    vertex_src.data.getBytes(&vertArray, length:count * sizeof(Float))
   



    for (var i:NSInteger = 0; i<vectorCount; i++) {
        // The range of bytes for this vector
        let byteRange: NSRange = NSMakeRange(i*stride + offset, // Start at current stride + offset
            bytesPerVector);   // and read the lenght of one vector
        
        // create array of appropriate length:
        var array = [Float](count: 3, repeatedValue: 0)
        var normalArray = [Float](count: 3, repeatedValue: 0)
        // copy bytes into array
        
        vertex_src.data.getBytes(&array, range: byteRange)
        normal_src.data.getBytes(&normalArray, range: byteRange)
        
        // At this point you can read the data from the float array
       // let octaves = 10
        
      //  var factor:Double = Double(norm3D(array[0], y:array[1] , z: array[2]))
        var factor = 7.0
     //   print(simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor))
        
        var disp:Double = 0.0
        //disp = simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor)
        for o in 1...octaves{
            disp += simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor)
            factor *= 2
        }
        
        disp = disp/Double(octaves)
        disp = disp/Double(amplitude)
        
        
      
        var x,y,z:Float
        if(radius+CGFloat(disp)<floor){
            x = array[0]    //lost precision but okay for now
            y = array[1]
            z = array[2]
        }
        else{
        
        x = array[0]+normalArray[0]*Float(disp)    //lost precision but okay for now
        y = array[1]+normalArray[1]*Float(disp)
        z = array[2]+normalArray[2]*Float(disp)
        }
        
        vertArray[3*i] = x
        vertArray[(3*i)+1] = y
        vertArray[(3*i)+2] = z
        
        
    }

    let data:NSData = NSData(bytes: vertArray, length: Int(vectorCount * 3 * sizeof(Float)))
    let source:SCNGeometrySource = SCNGeometrySource(data:data,
        semantic:SCNGeometrySourceSemanticVertex,
        vectorCount:vectorCount,
        floatComponents:true,
        componentsPerVector:3,
        bytesPerComponent:sizeof(Float),
        dataOffset:0,
        dataStride:sizeof(Float)*3)
    
    
    
    
    
    
    let geomElement:SCNGeometryElement = SCNGeometryElement(
        data: sph.geometryElementAtIndex(0).data,
        primitiveType: SCNGeometryPrimitiveType.Triangles,
        primitiveCount: sph.geometryElementAtIndex(0).primitiveCount,
        bytesPerIndex: 2)
    
    
    let geometry:SCNGeometry = SCNGeometry(sources:[source, normal_src, texture_src], elements:[geomElement])
    

    
    return geometry
    
    
    
}







