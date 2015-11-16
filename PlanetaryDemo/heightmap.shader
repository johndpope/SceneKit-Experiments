

uniform float radius = 1.0;
uniform float seaLevel = 1.0;
uniform float elevation = 1.0;
uniform int bodyType;

#pragma transparent
#pragma body


vec4 orig = _surface.diffuse;
vec4 transformed_position = u_inverseModelTransform * u_inverseViewTransform * vec4(_surface.position, 1.0);
vec4 pos = transformed_position;
//_surface.diffuse = mix(vec4((sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z)-radius)/radius/2,0.0,0.0,1.0), orig, 0.5);

float mag = sqrt(pos.x*pos.x+pos.y*pos.y+pos.z*pos.z);

vec4 lowcolor = vec4(0.0,0.0,0.3,1.0);


if(mag<radius){
_surface.diffuse = lowcolor;
}
else if(mag<radius+0.05){
_surface.diffuse = vec4(0.3,0.3,0.0,1.0);
}
else{
_surface.diffuse = mix(vec4((mag-(radius+seaLevel))/180,0.3,0.0,1.0), vec4(1.0,1.0,1.0,1.0), (mag-radius)/2);

}