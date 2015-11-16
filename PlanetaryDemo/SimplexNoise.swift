//
//  SimplexNoise.swift
//  Perlin's Simplex Noise
//
//  Created by Jacob Martin on 9/1/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//
//Thank you Stefan Gustavson for your elucidating simplex noise...
//http://webstaff.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf
//

import Foundation


func FASTFLOOR(x:Double) -> Int { return x>0 ? Int(x) : Int(x-1) }

    var perm = [151,160,137,91,90,15,
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
    151,160,137,91,90,15,
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180]


func grad1(hash:Int, x:Double) -> Double{
   let h = hash & 15
    var grad:Double = 1.0 + Double(h & 7)
    if (h&8 != 0){ grad = -grad }
    return grad*x
}

func grad2(hash:Int, x:Double, y:Double) -> Double{
    let h = hash & 7
    let u:Double = h<4 ? x : y
    let v:Double = h<4 ? y : x

    return ((h&1 != 0) ? -u: u) + ((h&2 != 0) ? -2.0*v : 2.0*v)
}

func grad3(hash:Int, x:Double, y:Double, z:Double) -> Double{
    let h = hash & 15
    let u:Double = h<8 ? x : y
    let v:Double = h<4 ? y : h==12 || h==14 ? x : z
    
    return ((h&1 != 0) ? -u : u) + ((h&2 != 0) ? -v : v)
}

func grad4(hash:Int, x:Double, y:Double, z:Double, t:Double) -> Double{
    let h = hash & 7
    let u:Double = h<24 ? x : y
    let v:Double = h<16 ? y : z
    let w:Double = h<8 ? z : t
    
    return ((h&1 != 0) ? -u : u) + ((h&2 != 0) ? -v : v) + ((h&4 != 0) ? -w : w);
}





//1 Dimensional Simplex Noise
func simplexNoise1D(x:Double) -> Double{
    
    let i0 = FASTFLOOR(x)
    let i1 = i0 + 1
    let x0 = x - Double(i0)
    let x1 = x0 - 1.0
    
    var n0,n1:Double
   
    var t0 = 1.0 - x0*x0
    t0 *= t0
    
    n0 = t0 * t0 * grad1(perm[i0 & 0xff], x:x0)
    
    var t1 = 1.0 - x1*x1
    t1 *= t1
    n1 = t1 * t1 * grad1(perm[i1 & 0xff], x:x1)
    
    return 0.25 * (n0 + n1)
}

//2 Dimensional Simplex Noise
func simplexNoise2D(x:Double, y:Double) -> Double{
  
    let F2 = 0.366025403 // (sqrt(5.0)-1.0)/4.0
    let G2 = 0.211324865 // (5.0-sqrt(5.0))/20.0

    var n0, n1, n2:Double
    
    let s = (x+y)*F2
    let xs = x + s;
    let ys = y + s;
    let i = FASTFLOOR(xs);
    let j = FASTFLOOR(ys);
    
    let t = Double(i+j)*G2;
    let X0 = Double(i)-t; // Unskew the cell origin back to (x,y) space
    let Y0 = Double(j)-t;
    let x0 = x-X0; // The x,y distances from the cell origin
    let y0 = y-Y0;
    
    // For the 2D case, the simplex shape is an equilateral triangle.
    // Determine which simplex we are in.
    var i1,j1:Int; // Offsets for second (middle) corner of simplex in (i,j) coords
    if(x0>y0) {i1=1; j1=0;} // lower triangle, XY order: (0,0)->(1,0)->(1,1)
    else {i1=0; j1=1;}      // upper triangle, YX order: (0,0)->(0,1)->(1,1)
    
    // A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
    // a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
    // c = (3-sqrt(3))/6
    
    let x1 = x0 - Double(i1) + G2; // Offsets for middle corner in (x,y) unskewed coords
    let y1 = y0 - Double(j1) + G2;
    let x2 = x0 - 1.0 + 2.0 * G2; // Offsets for last corner in (x,y) unskewed coords
    let y2 = y0 - 1.0 + 2.0 * G2;
    
    // Wrap the integer indices at 256, to avoid indexing perm[] out of bounds
    let ii = i & 0xff;
    let jj = j & 0xff;
    
    // Calculate the contribution from the three corners
    var t0 = 0.5 - x0*x0-y0*y0;
    if(t0 < 0.0) {n0 = 0.0}
    else {
        t0 *= t0;
        n0 = t0 * t0 * grad2(perm[ii+perm[jj]], x: x0, y: y0);
    }
    
    var t1 = 0.5 - x1*x1-y1*y1;
    if(t1 < 0.0) {n1 = 0.0}
    else {
        t1 *= t1
        n1 = t1 * t1 * grad2(perm[ii+i1+perm[jj+j1]], x: x1, y: y1);
    }
    
    var t2 = 0.5 - x2*x2-y2*y2;
    if(t2 < 0.0) {n2 = 0.0}
    else {
        t2 *= t2;
        n2 = t2 * t2 * grad2(perm[ii+1+perm[jj+1]], x: x2, y: y2);
    }
    
    // Add contributions from each corner to get the final noise value.
    // The result is scaled to return values in the interval [-1,1].
    return 40.0 * (n0 + n1 + n2); // TODO: The scale factor is preliminary!

}

//3 Dimensional Simplex Noise
func simplexNoise3D(x:Double, y:Double, z:Double) -> Double{
    
    let F3 = 0.333333333
    let G3 = 0.166666667
    
    var n0,n1,n2,n3:Double
    //print(perm.count)
    // Skew the input space to determine which simplex cell we're in
    let s = (x+y+z)*F3 // Very nice and simple skew factor for 3D
    let xs = x+s
    let ys = y+s
    let zs = z+s
    let i = FASTFLOOR(xs)
    let j = FASTFLOOR(ys)
    let k = FASTFLOOR(zs)
    
    let t = Double(i+j+k)*G3
    let X0 = Double(i)-t; // Unskew the cell origin back to (x,y,z) space
    let Y0 = Double(j)-t;
    let Z0 = Double(k)-t;
    let x0 = x-X0; // The x,y,z distances from the cell origin
    let y0 = y-Y0;
    let z0 = z-Z0;
    
    // For the 3D case, the simplex shape is a slightly irregular tetrahedron.
    // Determine which simplex we are in.
    var i1,j1,k1:Int // Offsets for second corner of simplex in (i,j,k) coords
    var i2,j2,k2:Int // Offsets for third corner of simplex in (i,j,k) coords
    
    /* This code would benefit from a backport from the GLSL version! */
    if(x0>=y0) {
        if(y0>=z0)
        { i1=1; j1=0; k1=0; i2=1; j2=1; k2=0; } // X Y Z order
        else if(x0>=z0) { i1=1; j1=0; k1=0; i2=1; j2=0; k2=1; } // X Z Y order
        else { i1=0; j1=0; k1=1; i2=1; j2=0; k2=1; } // Z X Y order
    }
    else { // x0<y0
        if(y0<z0) { i1=0; j1=0; k1=1; i2=0; j2=1; k2=1; } // Z Y X order
        else if(x0<z0) { i1=0; j1=1; k1=0; i2=0; j2=1; k2=1; } // Y Z X order
        else { i1=0; j1=1; k1=0; i2=1; j2=1; k2=0; } // Y X Z order
    }
    
    // A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
    // a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
    // a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
    // c = 1/6.
    
    let x1 = x0 - Double(i1) + G3 // Offsets for second corner in (x,y,z) coords
    let y1 = y0 - Double(j1) + G3
    let z1 = z0 - Double(k1) + G3
    let x2 = x0 - Double(i2) + 2.0*G3 // Offsets for third corner in (x,y,z) coords
    let y2 = y0 - Double(j2) + 2.0*G3
    let z2 = z0 - Double(k2) + 2.0*G3
    let x3 = x0 - 1.0 + 3.0*G3 // Offsets for last corner in (x,y,z) coords
    let y3 = y0 - 1.0 + 3.0*G3
    let z3 = z0 - 1.0 + 3.0*G3
    
    // Wrap the integer indices at 256, to avoid indexing perm[] out of bounds
    let ii = i & 0xff;
    let jj = j & 0xff;
    let kk = k & 0xff;
    
    // Calculate the contribution from the four corners
    var t0 = 0.6 - x0*x0 - y0*y0 - z0*z0
    if(t0 < 0.0) {n0 = 0.0}
    else {
        t0 *= t0;
        n0 = t0 * t0 * grad3(perm[ii+perm[jj+perm[kk]]], x: x0, y: y0, z: z0)
    }
    
    var t1 = 0.6 - x1*x1 - y1*y1 - z1*z1
    if(t1 < 0.0) {n1 = 0.0}
    else {
        t1 *= t1;
        n1 = t1 * t1 * grad3(perm[ii+i1+perm[jj+j1+perm[kk+k1]]], x: x1, y: y1, z: z1);
    }
    
    var t2 = 0.6 - x2*x2 - y2*y2 - z2*z2
    if(t2 < 0.0) {n2 = 0.0}
    else {
        t2 *= t2;
        n2 = t2 * t2 * grad3(perm[ii+i2+perm[jj+j2+perm[kk+k2]]], x: x2, y: y2, z: z2);
    }
    
    var t3 = 0.6 - x3*x3 - y3*y3 - z3*z3
    if(t3<0.0) {n3 = 0.0}
    else {
        t3 *= t3;
        n3 = t3 * t3 * grad3(perm[ii+1+perm[jj+1+perm[kk+1]]], x: x3, y: y3, z: z3);
    }
    
    // Add contributions from each corner to get the final noise value.
    // The result is scaled to stay just inside [-1,1]
    return 32.0 * (n0 + n1 + n2 + n3) // TODO: The scale factor is preliminary!

}

//4 Dimensional Simplex Noise (not yet implemented)
func simplexNoise4D(x:Double, y:Double, z:Double, w:Double) -> Double{
   
    

    let F4 = 0.309016994
    let G4 = 0.138196601
    
    var n0,n1,n2,n3,n4:Double
    
    
    return 0.0
}
