//#if GL_ES
//precision mediump float;
//#endif

#define PROCESSING_COLOR_SHADER

#define TAU 3.14159265894 * 2.0

uniform sampler2D iChannel0;

uniform float width;
uniform float height;

uniform float time;

void main(){
	// p will range from -1 to 1
	vec2 p = 1.0 - 2.0 * gl_FragCoord.xy / vec2(width, height);
	p.x *= width/height;
	
	float pLength = length(p);
	
	// Use polar coordinate to sample the texture
	vec2 texel = vec2( mod(1.0/pLength + time * 0.3, 1.0), mod(atan(p.y/p.x)/TAU, 1.0));
	
    vec4 fogCol = vec4(vec3(0.75) * pLength/2.0, 1.0);

	gl_FragColor = texture2D(iChannel0, texel) * fogCol;
}