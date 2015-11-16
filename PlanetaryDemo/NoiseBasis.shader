int FASTFLOOR(float x){ return x>0 ? x : x-1; }

float grad3(int hash, float x, float y, float z){
int h = hash & 15;
float u = h<8 ? x : y;
float v = h<4 ? y : h==12 || h==14 ? x : z;

return (((h&1) != 0) ? -u : u) + (((h&2) != 0) ? -v : v);
}






float simplex(vec3 pos) {

int perm[512] = {151,160,137,91,90,15,
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
138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180};


float F3 = 0.333333333;
float G3 = 0.166666667;

float x = pos.x;
float y = pos.y;
float z = pos.z;

float n0;
float n1;
float n2;
float n3;


// Skew the input space to determine which simplex cell we're in
float s = (x+y+z)*F3; // Very nice and simple skew factor for 3D
float xs = x+s;
float ys = y+s;
float zs = z+s;
int i = FASTFLOOR(xs);
int j = FASTFLOOR(ys);
int k = FASTFLOOR(zs);

float t = (i+j+k)*G3;
float X0 = (i)-t; // Unskew the cell origin back to (x,y,z) space
float Y0 = (j)-t;
float Z0 = (k)-t;
float x0 = x-X0; // The x,y,z distances from the cell origin
float y0 = y-Y0;
float z0 = z-Z0;

// For the 3D case, the simplex shape is a slightly irregular tetrahedron.
// Determine which simplex we are in.
int i1;
int j1;
int k1; // Offsets for second corner of simplex in (i,j,k) coords
int i2;
int j2;
int k2; // Offsets for third corner of simplex in (i,j,k) coords

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

float x1 = x0 - (i1) + G3; // Offsets for second corner in (x,y,z) coords
float y1 = y0 - (j1) + G3;
float z1 = z0 - (k1) + G3;
float x2 = x0 - (i2) + 2.0*G3; // Offsets for third corner in (x,y,z) coords
float y2 = y0 - (j2) + 2.0*G3;
float z2 = z0 - (k2) + 2.0*G3;
float x3 = x0 - 1.0 + 3.0*G3; // Offsets for last corner in (x,y,z) coords
float y3 = y0 - 1.0 + 3.0*G3;
float z3 = z0 - 1.0 + 3.0*G3;

// Wrap the integer indices at 256, to avoid indexing perm[] out of bounds
int ii = i & 0xff;
int jj = j & 0xff;
int kk = k & 0xff;

// Calculate the contribution from the four corners
float t0 = 0.6 - x0*x0 - y0*y0 - z0*z0;
if(t0 < 0.0) {n0 = 0.0;}
else {
t0 *= t0;
n0 = t0 * t0 * grad3(perm[ii+perm[jj+perm[kk]]], x0, y0, z0);
}

float t1 = 0.6 - x1*x1 - y1*y1 - z1*z1;
if(t1 < 0.0) {n1 = 0.0;}
else {
t1 *= t1;
n1 = t1 * t1 * grad3(perm[ii+i1+perm[jj+j1+perm[kk+k1]]], x1, y1, z1);
}

float t2 = 0.6 - x2*x2 - y2*y2 - z2*z2;
if(t2 < 0.0) {n2 = 0.0;}
else {
t2 *= t2;
n2 = t2 * t2 * grad3(perm[ii+i2+perm[jj+j2+perm[kk+k2]]], x2, y2, z2);
}

float t3 = 0.6 - x3*x3 - y3*y3 - z3*z3;
if(t3<0.0) {n3 = 0.0;}
else {
t3 *= t3;
n3 = t3 * t3 * grad3(perm[ii+1+perm[jj+1+perm[kk+1]]], x3, y3, z3);
}

// Add contributions from each corner to get the final noise value.
// The result is scaled to stay just inside [-1,1]

//_geometry.position.xyz += _geometry.normal*(32.0 * (n0 + n1 + n2 + n3))*5; // TODO: The scale f
return 32.0 * (n0 + n1 + n2 + n3);  // TODO: The scale f
}


#pragma transparent
#pragma body


float disp += simplex(_geometry.position.xyz/50);




_geometry.position.xyz += _geometry.normal*disp*3;




