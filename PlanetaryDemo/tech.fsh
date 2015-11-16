uniform sampler2D colorSampler;
uniform sampler2D normalSampler;

varying vec2 uv;
uniform vec2 size;
uniform float u_time;

void main() {
  
    gl_FragColor.rgb = vec3(0.0,0.0,0.0);
    gl_FragColor.a = 1.0;
}