

uniform float radius = 1.0;
uniform float seaLevel = 1.0;
uniform float elevation = 1.0;

int FASTFLOOR(float x){ return x>0 ? x : x-1; }

float grad3(int hash, float x, float y, float z){
int h = hash & 15;
float u = h<8 ? x : y;
float v = h<4 ? y : h==12 || h==14 ? x : z;

return (((h&1) != 0) ? -u : u) + (((h&2) != 0) ? -v : v);
}







#pragma transparent
#pragma body


vec4 orig = _surface.diffuse;
vec4 transformed_position = u_inverseModelTransform * u_inverseViewTransform * vec4(_surface.position, 1.0);
vec4 pos = transformed_position;
//_surface.diffuse = mix(vec4((sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)-radius)/radius/2,0.0,0.0,1.0), orig, 0.5);

if(sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)<radius){
_surface.diffuse = vec4(0.0,0.0,0.3,1.0);
}
else if(sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)<radius+0.05){
_surface.diffuse = vec4(0.3,0.3,0.0,1.0);
}
else{
_surface.diffuse = mix(vec4((sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)-(radius+seaLevel))/180,0.3,0.0,1.0), vec4(1.0,1.0,1.0,1.0), (sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)-radius)/2);

}